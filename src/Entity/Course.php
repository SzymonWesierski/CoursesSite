<?php

namespace App\Entity;

use App\Repository\CourseRepository;
use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;

#[ORM\Entity(repositoryClass: CourseRepository::class)]
class Course extends BaseCourse
{
    #[ORM\OneToOne(inversedBy: 'course', cascade: ['persist', 'remove'])]
    #[ORM\JoinColumn(nullable: false)]
    private ?CourseDraft $courseDraft = null;

    #[ORM\ManyToOne(inversedBy: 'courses')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $user = null;

    /**
     * @var Collection<int, Chapter>
     */
    #[ORM\OneToMany(targetEntity: Chapter::class, mappedBy: 'course', orphanRemoval: true, cascade:["persist", "remove"])]
    private Collection $chapters;

    /**
     * @var Collection<int, Cart>
     */
    #[ORM\ManyToMany(targetEntity: Cart::class, mappedBy: 'courses')]
    private Collection $carts;

    /**
     * @var Collection<int, Rating>
     */
    #[ORM\OneToMany(targetEntity: Rating::class, mappedBy: 'course', orphanRemoval: true)]
    private Collection $ratings;

    #[ORM\Column]
    private ?float $ratingAverage = null;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false)]
    private ?Category $category = null;

    public function __construct()
    {
        parent::__construct();
        $this->chapters = new ArrayCollection();
        $this->carts = new ArrayCollection();
        $this->ratings = new ArrayCollection();
    }

    public function getCourseDraft(): ?CourseDraft
    {
        return $this->courseDraft;
    }

    public function setCourseDraft(CourseDraft $courseDraft): static
    {
        $this->courseDraft = $courseDraft;

        return $this;
    }

    public function getUser(): ?User
    {
        return $this->user;
    }

    public function setUser(?User $user): static
    {
        $this->user = $user;
        return $this;
    }

    /**
     * @return Collection<int, Cart>
     */
    public function getCarts(): Collection
    {
        return $this->carts;
    }

    public function addCart(Cart $cart): static
    {
        if (!$this->carts->contains($cart)) {
            $this->carts->add($cart);
            $cart->addCourse($this);
        }

        return $this;
    }

    public function removeCart(Cart $cart): static
    {
        if ($this->carts->removeElement($cart)) {
            $cart->removeCourse($this);
        }

        return $this;
    }

    /**
     * @return Collection<int, Rating>
     */
    public function getRatings(): Collection
    {
        return $this->ratings;
    }

    public function addRating(Rating $rating): static
    {
        if (!$this->ratings->contains($rating)) {
            $this->ratings->add($rating);
            $rating->setCourse($this);
        }

        return $this;
    }

    public function removeRating(Rating $rating): static
    {
        if ($this->ratings->removeElement($rating)) {
            // set the owning side to null (unless already changed)
            if ($rating->getCourse() === $this) {
                $rating->setCourse(null);
            }
        }

        return $this;
    }

    public function getRatingAverage(): ?float
    {
        return $this->ratingAverage;
    }

    public function setRatingAverage(float $ratingAverage): static
    {
        $this->ratingAverage = round($ratingAverage, 2);;

        return $this;
    }

    public function getCategory(): ?Category
    {
        return $this->category;
    }

    public function setCategory(?Category $category): static
    {
        $this->category = $category;

        return $this;
    }

    public function getChapters(): Collection
    {
        return $this->chapters;
    }

    public function addChapter(Chapter $chapter): static
    {
        if (!$this->chapters->contains($chapter)) {
            $this->chapters->add($chapter);
            $chapter->setCourse($this);
        }

        return $this;
    }

    public function setChapters(?Collection $chapters): static
    {
        $this->chapters = $chapters;
        return $this;
    }

    public function removeChapter(Chapter $chapter): static
    {
        if ($this->chapters->removeElement($chapter)) {
            if ($chapter->getCourse() === $this) {
                $chapter->setCourse(null);
            }
        }

        return $this;
    }
    

}