<?php

namespace App\Controller;

use App\Entity\User;
use App\Entity\Course;
use App\Entity\Rating;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class RatingController extends AbstractController
{
    private $em;


    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
    }

    #[Route('/rate/course', name: 'course_rating')]
    public function index(Request $request): Response
    {
        $userId = $request->request->get('userId');
        $user = $this->em->getRepository(User::class)->find($userId);
        if (!$userId) {
            throw $this->createNotFoundException('User not found.');
        }

        $courseId = $request->request->get('courseId');
        $course = $this->em->getRepository(Course::class)->find($courseId);
        if (!$courseId) {
            throw $this->createNotFoundException('Course not found.');
        }

        $ratingValue = $request->request->get('rating');
        if (!$ratingValue) {
            throw $this->createNotFoundException('Rating not found.');
        }
        
        $rating = $this->em->getRepository(Rating::class)->findRatingByCourseIdUserId($userId, $courseId);

        if($rating == null){
            $rating = new Rating();
            $rating->setUser($user);
            $rating->setCourse($course);
            $rating->setValue($ratingValue);
        }
        else{
            $rating->setValue($ratingValue);
        }
        $this->em->persist($rating);
        $this->em->flush();
        
        //Calculating course ratingAverage
        $courseRatings = $this->em->getRepository(Rating::class)->findRatingsByCourseId($courseId);
        $ratingSum = 0;
        foreach($courseRatings as $r){
            $ratingSum += $r->getValue();
        }
        $course->setRatingAverage($ratingSum / count($courseRatings));
        $this->em->persist($course);
        
        $this->em->flush();

        return $this->redirectToRoute('show_course',["courseId" => $courseId ]);
    }
}
