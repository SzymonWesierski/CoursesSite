<?php

namespace App\Controller;

use App\Entity\Chapter;
use App\Entity\Course;
use App\Form\ChapterFormType;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Doctrine\ORM\EntityManagerInterface;

class ChapterController extends AbstractController
{
    private $em;

    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
    }


    #[Route('/chapter/create', name: 'create_chapter')]
    public function create(Request $request): JsonResponse
    {
        $chapter = new Chapter();
        $form = $this->createForm(ChapterFormType::class, $chapter);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $chapter = $form->getData();

            $courseId = $request->request->get('course_id');
            $course = $this->em->getRepository(Course::class)->find($courseId);
            
            if ($course) {
                $this->em->persist($chapter);
                $course->addChapter($chapter);
                $this->em->persist($course);
                $this->em->flush();

                return new JsonResponse([
                    'status' => 'success',
                    'chapter' => [
                        'id' => $chapter->getId(),
                        'name' => $chapter->getName(),
                    ],
                    'courseId' => $courseId
                ]);
            }
        }

        return new JsonResponse(['status' => 'error', 'message' => 'Form is not valid.'], 400);

    }

}
