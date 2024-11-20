<?php

namespace App\Controller;

use App\Entity\Category;
use App\Form\CategoryFormType;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CategoriesController extends AbstractController
{
    private $categoryRepository;
    private $em;

    public function __construct(CategoryRepository $categoryRepository, EntityManagerInterface $em) {
        $this->categoryRepository = $categoryRepository;
        $this->em = $em;
    }

    #[Route('/categories', name: 'categories')]
    public function index(): Response
    {
        $categories = $this->categoryRepository->findRootCategories();

        $category = new Category();

        $category_form = $this->createForm(CategoryFormType::class, $category);

        return $this->render('categories/index.html.twig', [
            'categories' => $categories,
            'create_category_form' => $category_form,
            'edit_category_form' => $category_form
        ]);
    }

    #[Route('/categories/create/{parentId?}', name: 'create_category')]
    public function create(Request $request, $parentId): Response
    {
        $category = new Category();

        $category_form = $this->createForm(CategoryFormType::class, $category);

        $category_form->handleRequest($request);

         if ($category_form->isSubmitted() && $category_form->isValid()) {

            $parentId = $request->request->get('parent_id');

            if($parentId != null){
                $parent = $this->categoryRepository->find($parentId);
                $category->setParent($parent);
            }

            $this->em->persist($category);

            $this->em->flush();
            return $this->redirectToRoute('categories');
         }

        return $this->render('categories/_create.html.twig', [
            'create_category_form' => $category_form
        ]);
    }

    #[Route('/categories/edit/{categoryId?}', name: 'edit_category')]
    public function edit(Request $request, $categoryId): Response
    {
        if($categoryId > 0){
            $category = $this->categoryRepository->find($categoryId);
        }else{
            $categoryId = $request->request->get('category_id');
            $category = $this->categoryRepository->find($categoryId);
        }

        if (!$category) {
            throw $this->createNotFoundException('Category not found.');
        }

        $category_form = $this->createForm(CategoryFormType::class, $category);

        $category_form->handleRequest($request);

         if ($category_form->isSubmitted() && $category_form->isValid()) {
            $this->em->flush();
            return $this->redirectToRoute('categories');
         }

        return $this->render('categories/_edit.html.twig', [
            'edit_category_form' => $category_form
        ]);
    }

    #[Route('/categories/delete/{categoryId}', name: 'delete_category')]
    public function delete($categoryId): Response
    {
        $category = $this->categoryRepository->find($categoryId);

        if (!$category) {
            throw $this->createNotFoundException('Category not found.');
        } 

        if ( !$this->categoryRepository->findRelationWithCourses($categoryId) and $category->getChildren()->isEmpty()) {
            $this->em->remove($category);
            $this->em->flush();
        }

        return $this->redirectToRoute('categories');
    }
}
