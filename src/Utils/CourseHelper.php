<?php

namespace App\Utils;

use App\Entity\CourseDraft;

class CourseHelper
{
    public static function RemoveAllIdsFromCourseDraftsRelatedEnities (CourseDraft $course): CourseDraft
    {
        foreach($course->getChapters() as $chapter){
            $chapter->setId(null);
            foreach($chapter->getEpisodesDraft() as $episode){
                $episode->setId(null);
            }
        }
        return $course;
    }
}
