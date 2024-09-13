<?php
// src/Controller/CoursesController.php
namespace App\Controller;

use App\Entity\Course;
use App\Form\CourseType;
use App\Repository\CourseRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\File\Exception\FileException;

class CoursesController extends AbstractController
{
    private $em;
    private $courseRepository;

    public function __construct(EntityManagerInterface $em, CourseRepository $courseRepository) 
    {
        $this->em = $em;
        $this->courseRepository = $courseRepository;
    }


    #[Route('/', name: 'courses', methods:['GET'])]
    public function index(): Response
    {
        $courses = $this->courseRepository->findAll();

        return $this->render('courses/index.html.twig', [
            'courses' => $courses
        ]);
    }

    #[Route('/courses/show/{id}', methods: ['GET'], name: 'show_course')]
    public function show($id): Response
    {
        $course = $this->courseRepository->find($id);
        
        return $this->render('courses/show.html.twig', [
            'course' => $course
        ]);
    }

    #[Route('/courses/delete/{id}', methods: ['GET', 'DELETE'], name: 'delete_course')]
    public function delete($id): Response
    {
        $course = $this->courseRepository->find($id);
        $this->em->remove($course);
        $this->em->flush();

        return $this->redirectToRoute('courses');
    }

    #[Route('/courses/create', name: 'create_course')]
    public function create(Request $request): Response
    {
        $course = new Course();
        $form = $this->createForm(CourseType::class, $course);

        $form->handleRequest($request);

        if($form->isSubmitted() && $form->isValid()){
            $newCourse = $form->getData();
            $newCourse->setUser($this->getUser());
            $imagePath = $form->get('ImagePath')->getData();
            
            if ($imagePath) {
                $newFileName = uniqid() . '.' . $imagePath->guessExtension();

                try {
                    $imagePath->move(
                        $this->getParameter('kernel.project_dir') . '/public/uploads',
                        $newFileName
                    );
                } catch (FileException $e) {
                    return new Response($e->getMessage());
                }
                $newCourse->setImagePath('/uploads/' . $newFileName);
            }
            
            $this->em->persist($newCourse);
            $this->em->flush();

            return $this->redirectToRoute('courses');
        }

        return $this->render('courses/create.html.twig', [
            'form' => $form->createView()
        ]);
    }

    #[Route('/courses/edit/{id}', name: 'edit_course')]
    public function edit($id, Request $request): Response 
    {
        $course = $this->courseRepository->find($id);

        $form = $this->createForm(CourseType::class, $course);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {

            $imagePath = $form->get('ImagePath')->getData();

            if ($imagePath) {
                if ($course->getImagePath() !== null) {
                    if (file_exists(
                        $this->getParameter('kernel.project_dir') . $course->getImagePath()
                        )) {
                            $this->GetParameter('kernel.project_dir') . $course->getImagePath();
                    }
                    $newFileName = uniqid() . '.' . $imagePath->guessExtension();

                    try {
                        $imagePath->move(
                            $this->getParameter('kernel.project_dir') . '/public/uploads',
                            $newFileName
                        );
                    } catch (FileException $e) {
                        return new Response($e->getMessage());
                    }

                    $course->setImagePath('/uploads/' . $newFileName);
                    $this->em->flush();

                    return $this->redirectToRoute('courses');
                }
            } else {
                $course->setName($form->get('name')->getData());
                $course->setDescription($form->get('Description')->getData());

                $this->em->flush();
                return $this->redirectToRoute('courses');
            }
        }

        return $this->render('courses/edit.html.twig', [
            'form' => $form->createView()
        ]);
    }
}

