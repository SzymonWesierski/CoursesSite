<?php

namespace App\DataFixtures;

use App\Entity\Chapter;
use App\Entity\Course;
use App\Entity\Episode;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $this->loadCourses($manager); 
    }

    private function loadCourses(ObjectManager $manager): void
    {
        $chapter1 = new Chapter();
        $chapter1->setName("Theory - Symfony 4 & 5 core features");

        $episode1 = new Episode();
        $episode1->setName("Routes");
        $episode1->setDescription("You will know two ways of creating routes in Symfony");

        $episode2 = new Episode();
        $episode2->setName("Controllers");
        $episode2->setDescription("Basics about Symfony controllers");
        

        $chapter1->addEpisode($episode1);
        $chapter1->addEpisode($episode2);


        $manager->persist($episode1);
        $manager->persist($episode2);
        $manager->persist($chapter1);

        $chapter2 = new Chapter();
        $chapter2->setName("Paginate, sort and search - videos on the website and test it");

        $episode3 = new Episode();
        $episode3->setName("Search results");
        $episode3->setDescription("Search videos by title in the database and display them");
        

        $chapter2->addEpisode($episode3);
        
        $manager->persist($episode3);
        $manager->persist($chapter2);

        $course1 = new Course();
        $course1->setName("Symfony Web Development Complete Guide: Beginner To Advanced");
        $course1->setDescription("You will learn Symfony 4 & 5 from theory to advanced level by creating real life projects");
        $course1->setImagePath("/uploads/66e31ed8d3b64.jpg");
        $course1->addChapter($chapter1);
        $course1->addChapter($chapter2);

        $manager->persist($course1);

        $manager->flush();
    }
}
