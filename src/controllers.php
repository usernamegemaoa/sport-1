<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

//Request::setTrustedProxies(array('127.0.0.1'));

$app->match('/', function (Request $request) use ($app) {
    $sql = 'SELECT date FROM morning_statistics WHERE date >= :date LIMIT 1';
    $params = array(
        'date' => date('Y-m-d 06:00:00')
        );
    if (!$app['db']->executeQuery($sql, $params)->fetch()) {
        return $app->redirect($app['url_generator']->generate('hello'));
    }
    $sql = 'SELECT id, name FROM places';
    $dbPlaces = $app['db']->fetchAll($sql);
    foreach ($dbPlaces as $place) {
        $places[$place['id']] = $place['name'];
    }
    $builder = $app['form.factory']->createBuilder('form');
    $form = $builder
        ->setAction($app["url_generator"]->generate('dashboard'))
        ->add('value', 'integer', 
            array(
                'attr' => array(
                    'placeholder' => 'Количество подтягиваний',
                    'value' => '10'
                ),
                'required' => true
            )
        )
        ->add('place', 'choice', array(
            'choices' => $places
            ))
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $app['db']->insert('pullups', array(
                'value' => $data['value'],
                'place' => $data['place']
                ));
            return $app->redirect($app['url_generator']->generate('dashboard'));
        }
    }
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pullups ups JOIN places p ON ups.place = p.id';
    $pullups = $app['db']->fetchAll($sql);
    $sql = 'SELECT SUM(value) as sum FROM pullups';
    $sum = $app['db']->executeQuery($sql)->fetch();
    return $app['twig']->render('index.html', array(
        'pullups' => $pullups,
        'sum' => $sum,
        'form' => $form->createView()
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
    $sql = 'SELECT id, name FROM places';
    $dbPlaces = $app['db']->fetchAll($sql);
    foreach ($dbPlaces as $place) {
        $places[$place['id']] = $place['name'];
    }
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
    $sql = 'SELECT SUM(value) as sum FROM pullups';
    $sum = $app['db']->executeQuery($sql)->fetch();
    return $app['twig']->render('pullups.twig', array(
        'pullups' => $pullups,
        'sum' => $sum,
        'form' => $form->createView()
        ));
})
->bind('pullups')
;

$app->match('/pushups', function (Request $request) use ($app) {
    $sql = 'SELECT id, name FROM places';
    $dbPlaces = $app['db']->fetchAll($sql);
    foreach ($dbPlaces as $place) {
        $places[$place['id']] = $place['name'];
    }
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
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pushups ups JOIN places p ON ups.place = p.id';
    $pushups = $app['db']->fetchAll($sql);
    $sql = 'SELECT SUM(value) as sum FROM pushups';
    $sum = $app['db']->executeQuery($sql)->fetch();
    return $app['twig']->render('pushups.twig', array(
        'pushups' => $pushups,
        'sum' => $sum,
        'form' => $form->createView()
        ));
})
->bind('pushups')
;

$app->match('/hello', function (Request $request) use ($app) {
    $sql = 'SELECT id, value FROM conditions';
    $dbConditions = $app['db']->fetchAll($sql);
    foreach ($dbConditions as $condition) {
        $conditions[$condition['id']] = $condition['value'];
    }

    $sql = 'SELECT id, value FROM weather';
    $dbWeathers = $app['db']->fetchAll($sql);
    foreach ($dbWeathers as $weather) {
        $weathers[$weather['id']] = $weather['value'];
    }

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
