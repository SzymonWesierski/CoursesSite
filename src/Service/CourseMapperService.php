<?php

namespace App\Service;

use App\Entity\Course;
use App\Entity\Chapter;
use App\Entity\Episode;
use App\Entity\CourseDraft;
use App\Entity\ChapterDraft;
use App\Entity\EpisodeDraft;

class CourseMapperService {
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

    public function mapCourseDraftToCourseDraft(CourseDraft $course, CourseDraft $originCourse): CourseDraft {
        $course->setDescription($originCourse->getDescription());
        $course->setName($originCourse->getName());
        $course->setCategory($originCourse->getCategory());
        $course->setPrice($originCourse->getPrice());
        $course->setImagePath($originCourse->getImagePath());
        $course->setStatus($originCourse->getStatus());
        $course->setPublicImageId($originCourse->getPublicImageId());
        

        foreach ($originCourse->getChapters() as $chapterDraft) {
            $course->addChapter($this->mapChapterDraftToChapterDraft($chapterDraft));
        }
        return $course;
    }

    private function mapChapterDraftToChapterDraft(ChapterDraft $chapterDraft): ChapterDraft {
        $chapter = new ChapterDraft();
        $chapter->setName($chapterDraft->getName());

        foreach ($chapterDraft->getEpisodesDraft() as $episodeDraft) {
            $chapter->addEpisodeDraft($this->mapEpisodeDraftToEpisodeDraft($episodeDraft));
        }
        return $chapter;
    }

    private function mapEpisodeDraftToEpisodeDraft(EpisodeDraft $episodeDraft): EpisodeDraft {
        $episode = new EpisodeDraft();
        $episode->setName($episodeDraft->getName());
        $episode->setDescription($episodeDraft->getDescription());
        $episode->setVideoPath($episodeDraft->getVideoPath());
        $episode->setImagePath($episodeDraft->getImagePath());
        $episode->setIsFreeToWatch($episodeDraft->getIsFreeToWatch());
        return $episode;
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
