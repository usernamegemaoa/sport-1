<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

//Request::setTrustedProxies(array('127.0.0.1'));

$app->match('/', function (Request $request) use ($app) {
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
        ->add('add', 'submit')
        ->getForm();
    
    // Add check for same name
    $form->handleRequest($request);
    if ($form->isSubmitted()) {
        if ($form->isValid()) {
            $data = $form->getData();
            $value = $data['value'];
            $app['db']->insert('pullups', array(
                'value' => $value
                ));
            return $app->redirect($app['url_generator']->generate('dashboard'));
        }
    }
    $sql = 'SELECT value, timestamp FROM pullups';
    return $app['twig']->render('index.html', array(
        'pullups' => $app['db']->fetchAll($sql),
        'form' => $form->createView()
        ));
})
->bind('dashboard')
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
