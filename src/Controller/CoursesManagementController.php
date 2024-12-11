<?php

namespace App\Controller;

use App\Enum\CourseStatus;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CoursesManagementController extends AbstractController
{
    private $courseRepository;
    private $em;

    public function __construct(CourseRepository $courseRepository, EntityManagerInterface $em) {
        $this->courseRepository = $courseRepository;
        $this->em = $em;
    }

    #[Route('/courses/management/{page?}/{titleParam?}', defaults: ['page' => '1'], name: 'app_courses_management')]
    public function index(Request $request, $page, $titleParam): Response
    {   
        if ($titleParam == null) $titleParam = $request->query->get('titleParam');

        if($titleParam){
            $courses = $this->courseRepository->findAllByTitlePaginated($page, $titleParam);
        }else{
            $courses = $this->courseRepository->findAllPaginated($page);
        }
        
        
        return $this->render('courses_management/index.html.twig', [
            'paginator' => $courses,
            'statusValues' => [
                'NOT_DONE_YET' => CourseStatus::NOT_DONE_YET->value,
                'WAITING_FOR_APPROVAL' => CourseStatus::WAITING_FOR_APPROVAL->value,
                'APPROVED' => CourseStatus::APPROVED->value,
                'APPROVED_AND_DRAFT' => CourseStatus::APPROVED_AND_DRAFT->value,
                'BANNED' => CourseStatus::BANNED->value,
            ],
            'titleParam' => $titleParam
        ]);
    }

    #[Route('/approve/courses/management/{courseId}', name: 'approve_course')]
    public function approve($courseId): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $course->setStatus(CourseStatus::APPROVED);

        $this->em->flush();

        return $this->redirectToRoute('app_courses_management');
    }

    #[Route('/ban/courses/management/{courseId}', name: 'ban_course')]
    public function ban($courseId): Response
    {
        $course = $this->courseRepository->find($courseId);

        if (!$course) {
            throw $this->createNotFoundException('Course not found.');
        }

        $course->setStatus(CourseStatus::BANNED);

        $this->em->flush();

        return $this->redirectToRoute('app_courses_management');
    }


}
