<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class CoursesManagementController extends AbstractController
{
    #[Route('/courses/management', name: 'app_courses_management')]
    public function index(): Response
    {
        return $this->render('courses_management/index.html.twig', [
            'controller_name' => 'CoursesManagementController',
        ]);
    }
}
