<?php

namespace App\Service;

use App\Entity\Course;
use App\Entity\Chapter;
use App\Entity\Episode;
use App\Entity\CourseDraft;
use App\Entity\ChapterDraft;
use App\Entity\EpisodeDraft;

class DraftToCourseMapperService {
    public function mapCourseDraftToCourse(Course $course, CourseDraft $courseDraft): Course {
        $course->setDescription($courseDraft->getDescription());
        $course->setName($courseDraft->getName());
        $course->setCategory($courseDraft->getCategory());
        $course->setPrice($courseDraft->getPrice());
        $course->setImagePath($courseDraft->getImagePath());
        $course->setStatus($courseDraft->getStatus());
        $course->setPublicImageId($courseDraft->getPublicImageId());
        

        foreach ($courseDraft->getChapters() as $chapterDraft) {
            $course->addChapter($this->mapChapterDraftToChapter($chapterDraft));
        }
        return $course;
    }

    private function mapChapterDraftToChapter(ChapterDraft $chapterDraft): Chapter {
        $chapter = new Chapter();
        $chapter->setName($chapterDraft->getName());

        foreach ($chapterDraft->getEpisodesDraft() as $episodeDraft) {
            $chapter->addEpisode($this->mapEpisodeDraftToEpisode($episodeDraft));
        }
        return $chapter;
    }

    private function mapEpisodeDraftToEpisode(EpisodeDraft $episodeDraft): Episode {
        $episode = new Episode();
        $episode->setName($episodeDraft->getName());
        $episode->setDescription($episodeDraft->getDescription());
        $episode->setVideoPath($episodeDraft->getVideoPath());
        $episode->setImagePath($episodeDraft->getImagePath());
        $episode->setIsFreeToWatch($episodeDraft->getIsFreeToWatch());
        return $episode;
    }
}
