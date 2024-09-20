<?php

/// src/Repository/CategoryRepository.php

namespace App\Repository;

use App\Entity\Category;
use App\Entity\CategoryClosure;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class CategoryRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Category::class);
    }

    public function findChildren(Category $parent): array
    {
        return $this->findBy(['parent' => $parent]);
    }

    public function findCategoriesWithChildren(): array
    {
        return $this->createQueryBuilder('c')
            ->leftJoin('c.children', 'children')
            ->addSelect('children')
            ->where('c.parent IS NULL')
            ->getQuery()
            ->getResult();
    }

    public function findAllChildren(Category $category): array
    {
        $qb = $this->createQueryBuilder('c')
            ->where('c.parent = :parent')
            ->setParameter('parent', $category);

        $children = $qb->getQuery()->getResult();

        foreach ($children as $child) {
            $children = array_merge($children, $this->findAllChildren($child));
        }

        return $children;
    }
    
}