<?php

namespace App\Enum;

enum CourseStatus: string
{
    case NOT_DONE_YET = 'not_done_yet';
    case WAITING_FOR_APPROVAL = 'waiting_for_approval';
    case APPROVED = 'approved';
    case APPROVED_AND_DRAFT = 'approved_and_new_version_in_draft';
    case BANNED = 'banned';
    case DRAFT = 'draft';
    case TEMP = 'temp';
    case TO_BE_CHECKED = 'to_be_checked';
}
