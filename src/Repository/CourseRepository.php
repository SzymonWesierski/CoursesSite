<?php

namespace App\Repository;

use App\Enum\CourseStatus;
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

    public function findAllAprovedByCategoryAndHerChildren($categoryWithCihildrenCategory): array{
        return $this->createQueryBuilder('c')
            ->join('c.categories', 'cat')
            ->andWhere('c.status IN (:approved)')
            ->andWhere('cat IN (:categories)')
            ->setParameter('categories', $categoryWithCihildrenCategory)
            ->setParameter('approved', CourseStatus::APPROVED )
            ->getQuery()
            ->getResult();
    }

    public function findUserCoursesByCategoryAndHerChildren($categoryWithCihildrenCategory, $user): array{
        return $this->createQueryBuilder('c')
            ->join('c.categories', 'cat')
            ->join('c.user', 'u')
            ->andWhere('u IN (:user)')
            ->andWhere('cat IN (:categories)')
            ->setParameter('categories', $categoryWithCihildrenCategory)
            ->setParameter('user', $user)
            ->getQuery()
            ->getResult();
    }

    public function findUserAll($user): array{
        return $this->createQueryBuilder('c')
            ->join('c.user', 'u')
            ->andWhere('u IN (:user)')
            ->setParameter('user', $user)
            ->getQuery()
            ->getResult();
    }
    public function findAllApproved(): array{
        return $this->createQueryBuilder('c')
            ->andWhere('c.status IN (:approved)')
            ->setParameter('approved', CourseStatus::APPROVED )
            ->getQuery()
            ->getResult();
    }
}
