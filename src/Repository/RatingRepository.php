<?php

namespace App\Repository;

use App\Entity\Rating;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Rating>
 */
class RatingRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Rating::class);
    }

//    /**
//     * @return Rating[] Returns an array of Rating objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('r')
//            ->andWhere('r.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('r.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?Rating
//    {
//        return $this->createQueryBuilder('r')
//            ->andWhere('r.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }

    public function findRatingByCourseIdUserId(int $userId, string $courseId){
        return $this->createQueryBuilder('r')
           ->join('r.user', 'ruser' )
           ->join('r.course', 'rcourse')
           ->andWhere('ruser.id = :userId')
           ->andWhere('rcourse.id = :courseId')
           ->setParameter('userId', $userId)
           ->setParameter('courseId', $courseId)
           ->getQuery()
           ->getOneOrNullResult()
       ;
    }

    public function findRatingsByCourseId(string $courseId){
        return $this->createQueryBuilder('r')
           ->join('r.course', 'rcourse')
           ->andWhere('rcourse.id = :courseId')
           ->setParameter('courseId', $courseId)
           ->getQuery()
           ->getResult();
    }
}
