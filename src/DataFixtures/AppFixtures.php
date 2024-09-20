<?php

namespace App\DataFixtures;

use App\Entity\Category;
use App\Entity\Chapter;
use App\Entity\Course;
use App\Entity\Episode;
use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Doctrine\Persistence\ObjectManager;
use App\Repository\CategoryRepository;
use Faker\Factory;

class AppFixtures extends Fixture
{
    private UserPasswordHasherInterface $userPasswordHasher;
    private CategoryRepository $categoryRepository;

    public function __construct(UserPasswordHasherInterface $userPasswordHasher, CategoryRepository $categoryRepository)
    {
        $this->userPasswordHasher = $userPasswordHasher;
        $this->categoryRepository = $categoryRepository;
    }

    public function load(ObjectManager $manager): void
    {
        $faker = Factory::create();


        $this->loadUsers($manager, $faker);

        $this->loadCategories($manager, $faker);

        $this->loadCoursesWithChapters($manager, $faker);
    }

    private function loadUsers(ObjectManager $manager, $faker): void
    {
        for ($i = 0; $i < 20; $i++) {
            $user = new User();
            $user->setUsername($faker->userName);
            $user->setRoles(['ROLE_USER']);
            $user->setPassword($this->userPasswordHasher->hashPassword($user, 'test123'));
            $user->setEmail($faker->email);
            $user->setVerified(true);
            $manager->persist($user);
        }

        $manager->flush();
    }

    private function loadCategories(ObjectManager $manager, $faker): void
    {
        $categories = [];

        // Create top-level categories
        for ($i = 0; $i < 5; $i++) {
            $parentCategory = new Category();
            $parentCategory->setName($faker->word);
            $manager->persist($parentCategory);
            $categories[] = $parentCategory;

            // Create second-level categories
            for ($j = 0; $j < 3; $j++) {
                $subCategory1 = new Category();
                $subCategory1->setName($faker->word);
                $subCategory1->setParent($parentCategory);
                $manager->persist($subCategory1);
                $categories[] = $subCategory1;

                // Create third-level categories
                for ($k = 0; $k < 2; $k++) {
                    $subCategory2 = new Category();
                    $subCategory2->setName($faker->word);
                    $subCategory2->setParent($subCategory1);
                    $manager->persist($subCategory2);
                    $categories[] = $subCategory2;
                }
            }
        }


        $manager->flush();
    }


    private function loadCoursesWithChapters(ObjectManager $manager, $faker): void
    {
         $categories = $this->categoryRepository->findAll();

        for ($i = 0; $i < 20; $i++) {
            $course = new Course();
            $course->setName('Course ' . ($i + 1));
            $course->setDescription($faker->sentences(10, true));
            $course->setImagePath($faker->imageUrl());

            $chapter = new Chapter();
            $chapter->setName('Chapter 1 of Course ' . ($i + 1));
            
            $episode = new Episode();
            $episode->setName('Episode 1 of Course ' . ($i + 1));
            $episode->setDescription($faker->sentences(3, true));

            $chapter->addEpisode($episode);
            $course->addChapter($chapter);

            $randomCategory1 = $categories[array_rand($categories, 1)];
            $randomCategory2 = $categories[array_rand($categories, 1)];
            $course->addCategory($randomCategory1);
            $course->addCategory($randomCategory2);

            $userRepo = $manager->getRepository(User::class);
            $randomUser = $userRepo->findOneBy([], ['id' => 'ASC'], rand(0, 19), 1);
            $randomUser->addCourse($course);

            $manager->persist($chapter);
            $manager->persist($episode);
            $manager->persist($course);
        }

        $manager->flush();
    }
}
