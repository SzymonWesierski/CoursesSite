<?php

namespace App\Entity;

use App\Repository\EpisodeDraftRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: EpisodeDraftRepository::class)]
class EpisodeDraft extends BaseEpisode
{
    #[ORM\ManyToOne(inversedBy: 'episodesDraft')]
    private ?ChapterDraft $chapterDraft = null;

    public function getChapterDraft(): ?ChapterDraft
    {
        return $this->chapterDraft;
    }

    public function setChapterDraft(?ChapterDraft $chapterDraft): static
    {
        $this->chapterDraft = $chapterDraft;

        return $this;
    }
}
