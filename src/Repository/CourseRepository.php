<?php

namespace App\Repository;

use App\Enum\CourseStatus;
use App\Pagination\Paginator;
use App\Entity\Course;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Course>
 */
class CourseRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Course::class);
    }

//    /**
//     * @return Course[] Returns an array of Course objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('c')
//            ->andWhere('c.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('c.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?Course
//    {
//        return $this->createQueryBuilder('c')
//            ->andWhere('c.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }

    public function findAllAprovedByCategoryAndHerChildren($categoryWithCihildrenCategory, int $page = 1): Paginator{
        $qb = $this->createQueryBuilder('c')
            ->join('c.categories', 'cat')
            ->andWhere('c.status IN (:approved)')
            ->andWhere('cat IN (:categories)')
            ->setParameter('categories', $categoryWithCihildrenCategory)
            ->setParameter('approved', CourseStatus::APPROVED );
        
        return (new Paginator($qb))->paginate($page);
    }

    public function findAllApproved(int $page = 1): Paginator{
        $qb = $this->createQueryBuilder('c')
            ->andWhere('c.status IN (:approved)')
            ->setParameter('approved', CourseStatus::APPROVED );
        
        return (new Paginator($qb))->paginate($page);
            
    }       

    public function findUserCoursesByCategoryAndHerChildren($categoryWithCihildrenCategory, $user, int $page = 1): Paginator{
        $qb = $this->createQueryBuilder('c')
            ->join('c.categories', 'cat')
            ->join('c.user', 'u')
            ->andWhere('u IN (:user)')
            ->andWhere('cat IN (:categories)')
            ->setParameter('categories', $categoryWithCihildrenCategory)
            ->setParameter('user', $user);

        return (new Paginator($qb))->paginate($page);
    }

    public function findUserAll( $user, int $page = 1): Paginator{
        $qb = $this->createQueryBuilder('c')
            ->join('c.user', 'u')
            ->andWhere('u IN (:user)')
            ->setParameter('user', $user);

        return (new Paginator($qb))->paginate($page);
    }
    

    public function findByEpisodeId($episodeId): ?Course
    {
        return $this->createQueryBuilder('c')
            ->join('c.chapters', 'ch')
            ->join('ch.episodes', 'e')
            ->andWhere('e.id = :episodeId')
            ->setParameter('episodeId', $episodeId)
            ->getQuery()
            ->getOneOrNullResult();
    }

    public function findWithTheBestRating(): array{
        return $this->createQueryBuilder('c')
            ->orderBy('c.ratingAverage', 'DESC')
            ->setMaxResults(10)
            ->getQuery()
            ->getResult();
    }

    public function findPurchasedCourses(int $userId): array
    {
        return $this->createQueryBuilder('course')  
            ->innerJoin('course.carts', 'cart')
            ->innerJoin('cart.user', 'user') 
            ->andWhere('user.id = :userId') 
            ->andWhere('cart.purchased = true') 
            ->setParameter('userId', $userId)
            ->select('DISTINCT course')
            ->getQuery()
            ->getResult();
    }

    public function isPurchasedCourse(int $courseId, int $userId): bool
    {
        return (bool) $this->createQueryBuilder('course')
            ->innerJoin('course.carts', 'cart')
            ->innerJoin('cart.user', 'user')
            ->andWhere('user.id = :userId')
            ->andWhere('course.id = :courseId')
            ->andWhere('cart.purchased = true')
            ->setParameter('userId', $userId)
            ->setParameter('courseId', $courseId)
            ->select('1')
            ->getQuery()
            ->getOneOrNullResult();
    }


    public function findPurchasedCoursesIds(int $userId): array
    {
        $coursesIds = $this->createQueryBuilder('course')  
            ->innerJoin('course.carts', 'cart')
            ->innerJoin('cart.user', 'user') 
            ->andWhere('user.id = :userId') 
            ->andWhere('cart.purchased = true') 
            ->setParameter('userId', $userId)
            ->select('DISTINCT course.id')
            ->getQuery()
            ->getResult();

            return array_column($coursesIds, 'id');
    }

    public function findAllByTitlePaginated(int $page = 1, string $titleParam = ""): Paginator {
        $qb = $this->createQueryBuilder('c');

        $qb = $qb
            ->where($qb->expr()->like('c.name', ':titleParam'))
            ->setParameter('titleParam', '%' . $titleParam . '%');
    
        return (new Paginator($qb))->paginate($page); 
    }
}
