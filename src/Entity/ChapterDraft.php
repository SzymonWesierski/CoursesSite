<?php

namespace App\Entity;

use App\Repository\ChapterDraftRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ChapterDraftRepository::class)]
class ChapterDraft extends BaseChapter
{

    #[ORM\ManyToOne(inversedBy: 'chapterDrafts')]
    private ?CourseDraft $courseDraft = null;

    /**
     * @var Collection<int, EpisodeDraft>
     */
    #[ORM\OneToMany(targetEntity: EpisodeDraft::class, mappedBy: 'chapterDraft', orphanRemoval: true, cascade:["persist", "remove"])]
    private Collection $episodesDraft;

    public function __construct()
    {
        $this->episodesDraft = new ArrayCollection();
    }

    public function getCourseDraft(): ?CourseDraft
    {
        return $this->courseDraft;
    }

    public function setCourseDraft(?CourseDraft $courseDraft): static
    {
        $this->courseDraft = $courseDraft;

        return $this;
    }

    /**
     * @return Collection<int, EpisodeDraft>
     */
    public function getEpisodesDraft(): Collection
    {
        return $this->episodesDraft;
    }

    public function addEpisodeDraft(EpisodeDraft $episodesDraft): static
    {
        if (!$this->episodesDraft->contains($episodesDraft)) {
            $this->episodesDraft->add($episodesDraft);
            $episodesDraft->setChapterDraft($this);
        }

        return $this;
    }

    public function removeEpisodesDraft(EpisodeDraft $episodesDraft): static
    {
        if ($this->episodesDraft->removeElement($episodesDraft)) {
            if ($episodesDraft->getChapterDraft() === $this) {
                $episodesDraft->setChapterDraft(null);
            }
        }

        return $this;
    }
}
