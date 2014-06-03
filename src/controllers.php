<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

//Request::setTrustedProxies(array('127.0.0.1'));

$app->match('/', function (Request $request) use ($app) {
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
            return $app->redirect($app['url_generator']->generate('pullups'));
        }
    }
    $sql = 'SELECT ups.value as value, ups.timestamp as timestamp, p.name as placename FROM pullups ups JOIN places p ON ups.place = p.id WHERE ups.timestamp > :dates';
    $params = array(
        ':dates' => date('Y-m-d 00:00:00')
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
            $app['db']->insert('pushups', array(
                'value' => $data['value'],
                'place' => $data['place']
                ));
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
