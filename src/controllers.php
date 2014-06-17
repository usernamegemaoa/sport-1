<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
//Request::setTrustedProxies(array('127.0.0.1'));

$app->match('/', function (Request $request) use ($app) {
    if (!$app['security']->isGranted('ROLE_USER')) {
        return $app->redirect($app['url_generator']->generate('user.login'));
    }
    $sql = 'SELECT date FROM morning_statistics WHERE date >= :date LIMIT 1';
    $params = array(
        'date' => date('Y-m-d 06:00:00')
        );
    if (!$app['db']->executeQuery($sql, $params)->fetch()) {
        return $app->redirect($app['url_generator']->generate('hello'));
    }
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pullups ups JOIN places p ON ups.place = p.id';
    $pullups = $app['db']->fetchAll($sql);
    $sql = 'SELECT SUM(value) as sum FROM pullups';
    $sum = $app['db']->executeQuery($sql)->fetch();

    /**
     * Pullups history
     */
    $tmp = array();
    $sql = 'SELECT value, timestamp FROM pullups WHERE DATE_SUB(CURDATE(),INTERVAL :days DAY) <= timestamp LIMIT 1000';
    $params = array(
        'days' => 20
        );
    foreach ($app['db']->fetchAll($sql, $params) as $item) {
        $day = substr($item['timestamp'], 0, 10);
        if (!isset($tmp[$day])) {
            $tmp[$day] = 0;
        }
        $tmp[$day] += $item['value'];
    }
    foreach ($tmp as $date => $day) {
        $pullupsHistory[] = array(
            'period' => $date,
            'pullups' => $day
            );
    }

    /**
     * Pushups history
     */
    $tmp = array();
    $sql = 'SELECT value, timestamp FROM pushups WHERE DATE_SUB(CURDATE(),INTERVAL :days DAY) <= timestamp LIMIT 1000';
    $params = array(
        'days' => 20
        );
    foreach ($app['db']->fetchAll($sql, $params) as $item) {
        $day = substr($item['timestamp'], 0, 10);
        if (!isset($tmp[$day])) {
            $tmp[$day] = 0;
        }
        $tmp[$day] += $item['value'];
    }
    foreach ($tmp as $date => $day) {
        $pushupsHistory[] = array(
            'period' => $date,
            'pushups' => $day
            );
    }
    return $app['twig']->render('index.html', array(
        'pullupsHistory' => json_encode($pullupsHistory),
        'pushupsHistory' => json_encode($pushupsHistory)
        ));
})
->bind('dashboard')
;

// public function defaultForm () {
//     $form = $builder
//         ->setAction($app["url_generator"]->generate('pullups'))
//         ->add('value', 'integer', 
//             array(
//                 'attr' => array(
//                     'placeholder' => 'Количество подтягиваний',
//                     'value' => '10'
//                 ),
//                 'required' => true
//             )
//         )
//         ->add('place', 'choice', array(
//             'choices' => $places
//             ))
//         ->add('add', 'submit');
//     return $form;
// }

// public function getForm() {
//     $form = $this->defaultForm();
//     $form->add('place', 'choice', array(
//             'choices' => $places
//             ));
//     $form->getForm();
//     -----------------
//     или не полиформировать этот метод
// }

$app->match('/pullups', function (Request $request) use ($app) {
    // DRY ------------------------------------------------
    $sql = 'SELECT id, name FROM places';
    $dbPlaces = $app['db']->fetchAll($sql);
    foreach ($dbPlaces as $place) {
        $places[$place['id']] = $place['name'];
    }
    // DRY ------------------------------------------------

    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('pullups'))
        ->add('value', 'integer', 
            array(
                'attr' => array(
                    'placeholder' => 'Количество подтягиваний',
                    'value' => '10'
                ),
                'required' => true,
                'label' => 'Количество подтягиваний'
            )
        )
        ->add('place', 'choice', array(
            'label' => 'Где занимаешься?',
            'choices' => $places
            ))
        ->add('fatigue', 'integer', 
            array(
                'attr' => array(
                    'placeholder' => 'Усталость',
                    'value' => '5'
                ),
                'label' => 'Усталость',
                'required' => true
            )
        )
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->insert('pullups', array(
                'value' => $data['value'],
                'place' => $data['place'],
                'fatigue' => $data['fatigue']
                ));
            $app['session']->getFlashBag()->add('success', 'Подтягивания учтены. Так держать!');
            return $app->redirect($app['url_generator']->generate('pullups'));
        }
    }
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pullups ups JOIN places p ON ups.place = p.id WHERE ups.timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $pullups = $app['db']->fetchAll($sql, $params);
    $sql = 'SELECT SUM(value) as sum FROM pullups WHERE timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $sum = $app['db']->executeQuery($sql, $params)->fetch();
    return $app['twig']->render('pullups.twig', array(
        'pullups' => $pullups,
        'sum' => $sum,
        'form' => $form->createView()
        ));
})
->bind('pullups')
;

$app->match('/pushups', function (Request $request) use ($app) {
    // DRY ------------------------------------------------
    $sql = 'SELECT id, name FROM places';
    $dbPlaces = $app['db']->fetchAll($sql);
    foreach ($dbPlaces as $place) {
        $places[$place['id']] = $place['name'];
    }
    // DRY ------------------------------------------------

    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('pushups'))
        ->add('value', 'integer', 
            array(
                'attr' => array(
                    'placeholder' => 'Количество отжиманий',
                    'value' => '10'
                ),
                'label' => 'Количество отжиманий',
                'required' => true
            )
        )
        ->add('place', 'choice', array(
            'label' => 'Где занимаешься?',
            'choices' => $places
            ))
        ->add('fatigue', 'integer', 
            array(
                'attr' => array(
                    'placeholder' => 'Усталость',
                    'value' => '5'
                ),
                'label' => 'Усталость',
                'required' => true
            )
        )
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->insert('pushups', array(
                'value' => $data['value'],
                'place' => $data['place'],
                'fatigue' => $data['fatigue']
                ));
            $app['session']->getFlashBag()->add('success', 'Отжимания учтены. Будь крепким как скала!');
            return $app->redirect($app['url_generator']->generate('pushups'));
        }
    }
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pushups ups JOIN places p ON ups.place = p.id WHERE ups.timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $pushups = $app['db']->fetchAll($sql, $params);
    $sql = 'SELECT SUM(value) as sum FROM pushups WHERE timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $sum = $app['db']->executeQuery($sql, $params)->fetch();
    return $app['twig']->render('pushups.twig', array(
        'pushups' => $pushups,
        'sum' => $sum,
        'form' => $form->createView()
        ));
})
->bind('pushups')
;

$app->match('/hello', function (Request $request) use ($app) {
    // DRY ------------------------------------------------
    $sql = 'SELECT id, value FROM conditions';
    $dbConditions = $app['db']->fetchAll($sql);
    foreach ($dbConditions as $condition) {
        $conditions[$condition['id']] = $condition['value'];
    }
    // DRY ------------------------------------------------

    // DRY ------------------------------------------------
    $sql = 'SELECT id, value FROM weather';
    $dbWeathers = $app['db']->fetchAll($sql);
    foreach ($dbWeathers as $weather) {
        $weathers[$weather['id']] = $weather['value'];
    }
    // DRY ------------------------------------------------

    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('hello'))
        ->add('morning_condition', 'choice', array(
            'choices' => $conditions,
            'required' => true,
            'label' => 'Состояние утром'
            ))
        ->add('current_condition', 'choice', array(
            'choices' => $conditions,
            'required' => true,
            'label' => 'Состояние на данный момент'
            ))
        ->add('getup_time', 'time', array(
            'required' => true,
            'label' => 'Подъем был в ... (надеюсь что утра)'
            ))
        ->add('alarm_time', 'time', array(
            'required' => true,
            'label' => 'А будильник я ставил на ... '
            ))
        ->add('bed_time', 'time', array(
            'required' => true,
            'label' => 'К тому же я лег спать в ...'
            ))
        ->add('weather', 'choice', array(
            'choices' => $weathers,
            'required' => true,
            'label' => 'Погодка утром'
            ))
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->insert('morning_statistics', array(
                'morning_condition' => $data['morning_condition'],
                'current_condition' => $data['current_condition'],
                'getup_time' => $data['getup_time']->format('H:i:s'),
                'alarm_time' => $data['alarm_time']->format('H:i:s'),
                'bed_time' => $data['bed_time']->format('H:i:s'),
                'weather' => $data['weather']
                ));
            $app['session']->getFlashBag()->add('success', 'Утренняя статистика пополнена. Хорошено дня, Романыч!');
            return $app->redirect($app['url_generator']->generate('dashboard'));    
        } else {
            $app['session']->getFlashBag()->add('danger', 'Утренняя статистика утеряна... Нужно обновить вручную. Или исправляй баги ;-)');
            return $app->redirect($app['url_generator']->generate('hello'));
        }
    }
    return $app['twig']->render('hello.twig', array(
        'form' => $form->createView()
        ));
})
->bind('hello')
;

$app->match('/ration', function (Request $request) use ($app) {
    // DRY ------------------------------------------------
    $sql = 'SELECT id, value FROM ration_types';
    $dbTypes = $app['db']->fetchAll($sql);
    foreach ($dbTypes as $type) {
        $types[$type['id']] = $type['value'];
    }
    //------------------------------------------------

    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('ration'))
        ->add('time', 'time', array(
            'required' => true,
            'label' => 'Время приема пищи (текущее если не знаю),'
            ))
        ->add('kkal', 'integer', array(
            'label' => 'Знаю сколько съел в каллориях!'
            ))
        ->add('type', 'choice', array(
            'choices' => $types,
            'required' => true,
            'label' => 'Как поел?'
            ))
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $sql = 'SELECT number FROM ration WHERE timestamp > :dates ORDER BY timestamp DESC LIMIT 1';
            $params = array(
                'dates' => date('Y-m-d 00:00:00')
                );
            $lastRationInfo = $app['db']->executeQuery($sql, $params)->fetch();
            $app['db']->insert('ration', array(
                'time' => ($data['time']->format('H:i') != '00:00') ? $data['time']->format('H:i:s') : date('H:i:s'),
                'number' => ($lastRationInfo) ? $lastRationInfo['number'] + 1 : 1,
                'kkal' => $data['kkal'],
                'type' => $data['type']
                ));
            $sql = 'SELECT mark FROM ration_types WHERE id = :id LIMIT 1';
            $params = array(
                'id' => $data['type']
                );
            $typeInfo = $app['db']->executeQuery($sql, $params)->fetch();
            if ($typeInfo['mark'] >= 10) {
                $flashMessage = array(
                    'type' => 'success',
                    'message' => 'Отлично подкрепился! Строительного материала хватит. Продролжай в том же духе, но не забывай об Activity.'
                    );
            } elseif (($typeInfo['mark'] < 10 && $typeInfo['mark'] >= 5) || $data['type'] == 8) {
                $flashMessage = array(
                    'type' => 'warning',
                    'message' => 'Постарайся питаться нормально. Тебе нужен строительный материл для развития своего тела.'
                    );
            } else {
                $flashMessage = array(
                    'type' => 'danger',
                    'message' => 'Это никуда не годится! Ты должен обязательно восполнить уходящую энергию своего тела!'
                    );
            }
            $app['session']->getFlashBag()->add($flashMessage['type'], $flashMessage['message']);    
        } else {
            $app['session']->getFlashBag()->add('danger', 'Что-то пошло не так. Имеются ошибки при добавлении. Хорошо что в здоровом теле здоровый ум :-)');
        }
        return $app->redirect($app['url_generator']->generate('ration'));
    }

    $sql = 'SELECT r.time as time, r.number as number, r.kkal as kkal, t.value as type_name FROM ration r JOIN ration_types t WHERE t.id = r.type AND r.timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $rations = $app['db']->fetchAll($sql, $params);

    return $app['twig']->render('ration.twig', array(
        'rations' => $rations,
        'form' => $form->createView()
        ));
})
->bind('ration')
;

$app->match('/water', function (Request $request) use ($app) {
    // DRY ------------------------------------------------
    $sql = 'SELECT id, value FROM water_types';
    $dbTypes = $app['db']->fetchAll($sql);
    foreach ($dbTypes as $type) {
        $types[$type['id']] = $type['value'];
    }
    //------------------------------------------------

    $sql = 'SELECT SUM(value) as value FROM water_ration WHERE timestamp > :dates';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $todayWaterInfo = $app['db']->executeQuery($sql, $params)->fetch();

    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('water_ration'))
        ->add('time', 'time', array(
            'label' => 'Когда попил? (текущее время если не введено)'
            ))
        ->add('value', 'integer', array(
            'required' => true,
            'label' => 'Сколько выпил?'
            ))
        ->add('type', 'choice', array(
            'choices' => $types,
            'required' => true,
            'label' => 'Что пил?)'
            ))
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->insert('water_ration', array(
                'time' => ($data['time']->format('H:i') != '00:00') ? $data['time']->format('H:i:s') : date('H:i:s'),
                'type' => $data['type'],
                'value' => $data['value']
                ));
            $app['session']->getFlashBag()->add('success', 'Выпивать необходимо до 3-х литров воды! Ты же выпил: ' . ($todayWaterInfo['value']/1000) . ' л.');    
        } else {
            $app['session']->getFlashBag()->add('danger', 'Что-то пошло не так. Имеются ошибки при добавлении. Хорошо что в здоровом теле здоровый ум :-)');
        }
        return $app->redirect($app['url_generator']->generate('water_ration'));
    }

    $sql = 'SELECT w.time as time, w.value as value, t.value as type_name FROM water_ration w JOIN water_types t WHERE t.id = w.type AND w.timestamp > :dates ORDER BY w.time ASC';
    $params = array(
        'dates' => date('Y-m-d 00:00:00')
        );
    $rations = $app['db']->fetchAll($sql, $params);
    return $app['twig']->render('water_ration.twig', array(
        'rations' => $rations,
        'sum' => ($todayWaterInfo['value']) ? $todayWaterInfo['value'] : 0,
        'form' => $form->createView()
        ));
})
->bind('water_ration')
;

$app->match('/summer', function (Request $request) use ($app) {
    $sql = 'SELECT serial_number, name, anounce, detail_info, photo FROM summer';
    $weekends = $app['db']->fetchAll($sql);
    foreach ($weekends as &$day) {
        $startUnixTime = strtotime('7 June 2014') + (7 * ($day['serial_number'] - 1) * 24 * 60 * 60);
        $day['dates'] = array(
            'from' => date('d.m.Y', $startUnixTime),
            'to' => date('d.m.Y', $startUnixTime + (24 * 60 * 60))
            );
    }

    return $app['twig']->render('summer/summer.twig', array(
        'weekends' => $weekends
        ));

})
->bind('summer')
;

$app->match('/summer/modal/{serial_number}', function (Request $request, $serial_number) use ($app) {
   $sql = 'SELECT serial_number, name, anounce, detail_info, photo FROM summer WHERE serial_number = :serial_number LIMIT 1';
    $params = array(
        'serial_number' => $serial_number
        );
    $weekend = $app['db']->executeQuery($sql, $params)->fetch();
    $startUnixTime = strtotime('7 June 2014') + (7 * ($weekend['serial_number'] - 1) * 24 * 60 * 60);
    $weekend['dates'] = array(
        'from' => date('d.m.Y', $startUnixTime),
        'to' => date('d.m.Y', $startUnixTime + (24 * 60 * 60))
        );

    return $app['twig']->render('summer/modal.twig', array(
        'weekend' => $weekend
        ));

})
->bind('summer_modal')
;

$app->match('/summer/update/{serial_number}', function (Request $request, $serial_number) use ($app) {
    if ($serial_number == '0') {
        return $app->redirect($app['url_generator']->generate('summer'));
    }
    $sql = 'SELECT serial_number, name, anounce, detail_info, photo FROM summer WHERE serial_number = :serial_number LIMIT 1';
    $params = array(
        'serial_number' => $serial_number
        );
    $weekend = $app['db']->executeQuery($sql, $params)->fetch();
    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('summer_update', array('serial_number' => $serial_number)))
        ->add('name', 'text', array(
            'label' => 'Название праздника!',
            'required' => true,
            'data' => $weekend['name']
            ))
        ->add('anounce', 'textarea', array(
            'required' => true,
            'label' => 'Небольшое вступление',
            'data' => $weekend['anounce']
            ))
        ->add('detail_info', 'textarea', array(
            'required' => true,
            'label' => 'Суть развлекухи!',
            'data' => $weekend['detail_info']
            ))
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->update('summer', array(
                'name' => $data['name'],
                'anounce' => $data['anounce'],
                'detail_info' => $data['detail_info']
                ), array(
                'serial_number' => $weekend['serial_number']
                )
            );
            $app['session']->getFlashBag()->add('success', 'Что записали то и запомнило! Теперь не забудешь, если все записали конечно ;)');    
        } else {
            $app['session']->getFlashBag()->add('danger', 'Что-то пошло не так. Имеются ошибки при добавлении. Хорошо что в здоровом теле здоровый ум :-)');
        }
        return $app->redirect($app['url_generator']->generate('summer'));
    }

    return $app['twig']->render('summer/update.twig', array(
        'weekend' => $weekend,
        'form' => $form->createView()
        ));
})
->bind('summer_update')
->value('serial_number', '0')
;

$app->error(function (\Exception $e, $code) use ($app) {
    if ($app['debug']) {
        return;
    }

    // 404.html, or 40x.html, or 4xx.html, or error.html
    $templates = array(
        'errors/'.$code.'.html',
        'errors/'.substr($code, 0, 2).'x.html',
        'errors/'.substr($code, 0, 1).'xx.html',
        'errors/default.html',
    );

    return new Response($app['twig']->resolveTemplate($templates)->render(array('code' => $code)), $code);
});
