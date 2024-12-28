<?php

namespace App\Repository;

use App\Entity\CourseDraft;
use App\Pagination\Paginator;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;

/**
 * @extends ServiceEntityRepository<CourseDraft>
 */
class CourseDraftRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, CourseDraft::class);
    }

    //    /**
    //     * @return CourseDraft[] Returns an array of CourseDraft objects
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

    //    public function findOneBySomeField($value): ?CourseDraft
    //    {
    //        return $this->createQueryBuilder('c')
    //            ->andWhere('c.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->getQuery()
    //            ->getOneOrNullResult()
    //        ;
    //    }

    public function findUserDraftCoursesByCategoryAndHerChildren($categoryWithChildrenCategories, $user, int $page = 1): Paginator
    {
        $qb = $this->createQueryBuilder('cd')
            ->join('cd.course', 'c')
            ->join('c.category', 'cat')
            ->join('c.user', 'u')
            ->andWhere('u = :user')
            ->andWhere('cat IN (:categories)') 
            ->setParameter('categories', $categoryWithChildrenCategories)
            ->setParameter('user', $user);

        return (new Paginator($qb))->paginate($page);
    }

    public function findUserAllDraftCourses($user, int $page = 1): Paginator
    {
        $qb = $this->createQueryBuilder('cd')
            ->join('cd.course', 'c')
            ->join('c.user', 'u')
            ->andWhere('u = :user')
            ->setParameter('user', $user);

        return (new Paginator($qb))->paginate($page);
    }

    public function findAllDraftsByTitlePaginated(int $page = 1, $user, string $titleParam = ""): Paginator
    {
        $qb = $this->createQueryBuilder('cd');

        $qb = $qb
            ->join('cd.course', 'c')
            ->join('c.user', 'u')
            ->where('u = :user')
            ->andWhere($qb->expr()->like('LOWER(cd.name)', ':titleParam'))
            ->setParameter('titleParam', '%' . strtolower($titleParam) . '%')
            ->setParameter('user', $user);;

        return (new Paginator($qb))->paginate($page); 
    }


}
