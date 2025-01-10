<?php

namespace App\DataFixtures;

use Faker\Factory;
use App\Entity\Cart;
use App\Entity\User;
use App\Entity\Course;
use App\Entity\Category;
use App\Enum\CourseStatus;
use App\Entity\CourseDraft;
use App\Entity\ChapterDraft;
use App\Entity\EpisodeDraft;
use App\Repository\CategoryRepository;
use Doctrine\Persistence\ObjectManager;
use App\Service\CourseMapperService;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class AppFixtures extends Fixture
{
    private UserPasswordHasherInterface $userPasswordHasher;
    private CategoryRepository $categoryRepository;
    private CourseMapperService $draftToCourseMapperService;

    public function __construct(UserPasswordHasherInterface $userPasswordHasher, 
        CategoryRepository $categoryRepository,
        CourseMapperService $draftToCourseMapperService)
    {
        $this->userPasswordHasher = $userPasswordHasher;
        $this->categoryRepository = $categoryRepository;
        $this->draftToCourseMapperService = $draftToCourseMapperService;
    }

    public function load(ObjectManager $manager): void
    {

        $this->loadUsers($manager);

        $this->loadAdmin($manager);

        $this->loadCategories($manager);

        $this->loadCoursesWithChapters($manager, $this->draftToCourseMapperService);
    }

    private function loadAdmin(ObjectManager $manager): void
    {

        $admin = new User();
        $admin->setUsername("Admin");
        $admin->setRoles(['ROLE_ADMIN']);
        $admin->setPassword($this->userPasswordHasher->hashPassword($admin, 'admin1@'));
        $admin->setEmail("admin@email.com");
        $admin->setIsVerified(true);

        $manager->persist($admin);

        $cart = new Cart();
        $cart->setAmountOfProducts(0);
        $cart->setPurchased(false);
        $cart->setTotalValue(0);
        $cart->setUser($admin);

        $manager->persist($cart);

        $manager->flush();
    }

    private function loadUsers(ObjectManager $manager): void
    {
        for ($i = 0; $i < 20; $i++) {
            $user = new User();
            $user->setUsername("user" + $i);
            $user->setRoles(['ROLE_USER']);
            $user->setPassword($this->userPasswordHasher->hashPassword($user, 'test123'));
            $user->setEmail("user" + $i + "@gmail.com");
            $user->setIsVerified(true);

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

    private function loadCategories(ObjectManager $manager): void
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


    private function loadCoursesWithChapters(ObjectManager $manager, $draftToCourseMapperService): void
    {
         $categories = $this->categoryRepository->findLeafCategories();

        $loremIpsum = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." ;
        for ($i = 0; $i < 100; $i++) {
            $courseDraft = new CourseDraft();
            $courseDraft->setName('Course ' . ($i + 1));
            $courseDraft->setDescription($loremIpsum);
            $courseDraft->setImagePath("/images/course_example_image.png");
            $courseDraft->setStatus(CourseStatus::APPROVED);
            $courseDraft->setPrice($this->randomFloat(49.99, 99.99));

            

            $chapter = new ChapterDraft();
            $chapter->setName('Chapter 1 of Course ' . ($i + 1));
            
            $episode = new EpisodeDraft();
            $episode->setName('Episode 1 of Course ' . ($i + 1));
            $episode->setDescription($loremIpsum);
            $episode->setIsFreeToWatch(true);

            $episode2 = new EpisodeDraft();
            $episode2->setName('Episode 2 of Course ' . ($i + 1));
            $episode2->setDescription($loremIpsum);
            $episode2->setIsFreeToWatch(false);

            $episode3 = new EpisodeDraft();
            $episode3->setName('Episode 3 of Course ' . ($i + 1));
            $episode3->setDescription($loremIpsum);
            $episode3->setIsFreeToWatch(false);

            $chapter->addEpisodeDraft($episode);
            $chapter->addEpisodeDraft($episode2);
            $chapter->addEpisodeDraft($episode3);
            $courseDraft->addChapter($chapter);

            $randomCategory1 = $categories[array_rand($categories, 1)];

            $courseDraft->setCategory($randomCategory1);

            $manager->persist($chapter);
            $manager->persist($episode);
            $manager->persist($episode2);
            $manager->persist($episode3);
            $manager->persist($courseDraft);

            $course = new Course();
            $course = $this->draftToCourseMapperService->mapCourseDraftToCourse($course, $courseDraft);

            $course->setRatingAverage($this->randomFloat(3.0, 5.0));
            $userRepo = $manager->getRepository(User::class);
            $randomUser = $userRepo->findOneBy([], ['id' => 'ASC'], rand(0, 19), 1);
            $randomUser->addCourse($course);
            $course->setCourseDraft($courseDraft);

            $manager->persist($course);

        }

        $manager->flush();
    }

    private function randomFloat(float $min, float $max): float {
        return $min + mt_rand() / mt_getrandmax() * ($max - $min);
    }
}
