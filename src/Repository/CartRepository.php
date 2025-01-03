<?php

namespace App\Repository;

use App\Entity\Cart;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Cart>
 */
class CartRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Cart::class);
    }

//    /**
//     * @return Cart[] Returns an array of Cart objects
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

//    public function findOneBySomeField($value): ?Cart
//    {
//        return $this->createQueryBuilder('c')
//            ->andWhere('c.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }

        public function findNotPurchased(int $userId): ?Cart
        {
            return $this->createQueryBuilder('c')
                ->join('c.user', 'u')
                ->andWhere('u.id = (:userId)')
                ->andWhere('c.purchased = false')
                ->setParameter('userId', $userId)
                ->getQuery()
                ->getOneOrNullResult();
        }   

        public function findCoursesValue(int $cartId): array
        {
            $prices = $this->createQueryBuilder('c') 
                ->innerJoin('c.courses', 'co') 
                ->select('co.price') 
                ->where('c.id = :cartId') 
                ->setParameter('cartId', $cartId) 
                ->getQuery() 
                ->getResult(); 

            return array_column($prices, 'price');
        }

}
