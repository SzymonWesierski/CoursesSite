<?php

namespace App\DataFixtures;

use App\Entity\Chapter;
use App\Entity\Course;
use App\Entity\Episode;
use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    private UserPasswordHasherInterface $userPasswordHasher;

    public function __construct(UserPasswordHasherInterface $userPasswordHasher)
    {
        $this->userPasswordHasher = $userPasswordHasher;
    }

    public function load(ObjectManager $manager): void
    {
        $this->loadCoursesWithUser($manager); 
    }

    private function loadCoursesWithUser(ObjectManager $manager): void
    {
        $user = new User();
        $user->setUsername("testUser");
        $user->setRoles(['ROLE_USER']);
        $user->setPassword($this->userPasswordHasher->hashPassword($user, "test123"));
        $user->setEmail("test@wp.pl");
        $user->setVerified(true);

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

        $user->addCourse($course1);
        $manager->persist($user);

        $manager->flush();
    }
}
