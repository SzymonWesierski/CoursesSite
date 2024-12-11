<?php

namespace App\Entity;

use App\Repository\CourseDraftRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: CourseDraftRepository::class)]
class CourseDraft extends BaseCourse
{

    #[ORM\OneToOne(mappedBy: 'courseDraft', cascade: ['persist', 'remove'])]
    private ?Course $course = null;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false)]
    private ?Category $category = null;

    /**
     * @var Collection<int, Chapter>
     */
    #[ORM\OneToMany(targetEntity: ChapterDraft::class, mappedBy: 'courseDraft', orphanRemoval: true)]
    private Collection $chapters;

    public function __construct()
    {
        parent::__construct();
        $this->chapters = new ArrayCollection();
    }

    public function getCourse(): ?Course
    {
        return $this->course;
    }

    public function setCourse(Course $course): static
    {
        // set the owning side of the relation if necessary
        if ($course->getCourseDraft() !== $this) {
            $course->setCourseDraft($this);
        }

        $this->course = $course;

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

    /**
     * @return Collection<int, ChapterDraft>
     */
    public function getChapters(): Collection
    {
        return $this->chapters;
    }

    public function addChapter(ChapterDraft $chapters): static
    {
        if (!$this->chapters->contains($chapters)) {
            $this->chapters->add($chapters);
            $chapters->setCourseDraft($this);
        }

        return $this;
    }

    public function setChapters(?Collection $chapters): static
    {
        $this->chapters = $chapters;
        return $this;
    }

    public function removeChapter(Chapter $chapters): static
    {
        if ($this->chapters->removeElement($chapters)) {
            // set the owning side to null (unless already changed)
            if ($chapters->getCourse() === $this) {
                $chapters->setCourse(null);
            }
        }

        return $this;
    }
    
}
