<?php

namespace App\DataFixtures;

use App\Entity\Category;
use App\Entity\Chapter;
use App\Entity\Course;
use App\Entity\Episode;
use App\Entity\User;
use App\Entity\Cart;
use App\Enum\CourseStatus;
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

        $this->loadAdmin($manager);

        $this->loadCategories($manager, $faker);

        $this->loadCoursesWithChapters($manager, $faker);
    }

    private function loadAdmin(ObjectManager $manager): void
    {

        $admin = new User();
        $admin->setUsername("Admin");
        $admin->setRoles(['ROLE_ADMIN']);
        $admin->setPassword($this->userPasswordHasher->hashPassword($admin, 'admin1@'));
        $admin->setEmail("admin@email.com");
        $admin->setVerified(true);

        $manager->persist($admin);

        $manager->flush();
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

            $cart = new Cart();
            $cart->setAmountOfProducts(0);
            $cart->setPurchased(false);
            $cart->setTotalValue(0);
            $cart->setUser($user);

            $manager->persist($cart);

            
        }

        $manager->flush();
    }

    private function loadCategories(ObjectManager $manager, $faker): void
    {
        $categories = [];
        
        $categoriesNames = [
            "Development" => [
                "Web Development",
                "Mobile Development",
                "Game Development",
                "Data Science"
            ],
            "Business" => [
                "Entrepreneurship",
                "Management",
                "Business Strategy",
                "E-commerce"
            ],
            "Finance & Accounting" => [
                "Personal Finance",
                "Investing",
                "Accounting Basics",
                "Taxation"
            ],
            "IT & Software" => [
                "Software Engineering",
                "Cloud Computing",
                "Cybersecurity",
                "Networking"
            ],
            "Office Productivity" => [
                "Microsoft Office",
                "Google Workspace",
                "Project Management",
                "Time Management"
            ],
            "Personal Development" => [
                "Self-Help",
                "Motivation",
                "Career Development",
                "Public Speaking"
            ],
            "Design" => [
                "Graphic Design",
                "UX/UI Design",
                "Web Design",
                "3D Design"
            ],
            "Marketing" => [
                "Digital Marketing",
                "Content Marketing",
                "Social Media Marketing",
                "SEO"
            ],
            "Lifestyle" => [
                "Travel",
                "Cooking",
                "Fashion",
                "Personal Finance"
            ],
            "Photography & Video" => [
                "Photography Basics",
                "Video Editing",
                "Lighting Techniques",
                "Creative Photography"
            ],
            "Health & Fitness" => [
                "Nutrition",
                "Yoga",
                "Fitness Training",
                "Mental Health"
            ],
            "Music" => [
                "Music Theory",
                "Instrument Lessons",
                "Music Production",
                "Composition"
            ],
            "Teaching & Academics" => [
                "Teaching Strategies",
                "Educational Psychology",
                "Curriculum Development",
                "Online Teaching"
            ]
        ];
        

        foreach ($categoriesNames as $parentName => $subcategories) {
            $parentCategory = new Category();
            $parentCategory->setName($parentName); 
            $manager->persist($parentCategory);
            $categories[] = $parentCategory;
    
            foreach ($subcategories as $subcategoryName) {
                $subcategory = new Category(); 
                $subcategory->setName($subcategoryName); 
                $subcategory->setParent($parentCategory); 
                $manager->persist($subcategory);
            }
        }
        $manager->flush();
    }


    private function loadCoursesWithChapters(ObjectManager $manager, $faker): void
    {
         $categories = $this->categoryRepository->findLeafCategories();

        for ($i = 0; $i < 100; $i++) {
            $course = new Course();
            $course->setName('Course ' . ($i + 1));
            $course->setDescription($faker->sentences(10, true));
            $course->setImagePath("/images/course_example_image.png");
            $course->setStatus(CourseStatus::APPROVED);
            $course->setPrice($this->randomFloat(49.99, 99.99));
            $course->setRatingAverage($this->randomFloat(3.0, 5.0));

            $chapter = new Chapter();
            $chapter->setName('Chapter 1 of Course ' . ($i + 1));
            
            $episode = new Episode();
            $episode->setName('Episode 1 of Course ' . ($i + 1));
            $episode->setDescription($faker->sentences(3, true));
            $episode->setIsFreeToWatch(true);

            $episode2 = new Episode();
            $episode2->setName('Episode 2 of Course ' . ($i + 1));
            $episode2->setDescription($faker->sentences(3, true));
            $episode2->setIsFreeToWatch(false);

            $episode3 = new Episode();
            $episode3->setName('Episode 3 of Course ' . ($i + 1));
            $episode3->setDescription($faker->sentences(3, true));
            $episode3->setIsFreeToWatch(false);

            $chapter->addEpisode($episode);
            $chapter->addEpisode($episode2);
            $chapter->addEpisode($episode3);
            $course->addChapter($chapter);

            $randomCategory1 = $categories[array_rand($categories, 1)];

            $course->addCategory($randomCategory1);

            $userRepo = $manager->getRepository(User::class);
            $randomUser = $userRepo->findOneBy([], ['id' => 'ASC'], rand(0, 19), 1);
            $randomUser->addCourse($course);

            $manager->persist($chapter);
            $manager->persist($episode);
            $manager->persist($episode2);
            $manager->persist($episode3);
            $manager->persist($course);
        }

        $manager->flush();
    }

    private function randomFloat(float $min, float $max): float {
        return $min + mt_rand() / mt_getrandmax() * ($max - $min);
    }
}
