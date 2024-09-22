<?php

namespace App\Enum;

enum CourseStatus: string
{
    case NOT_DONE_YET = 'not_done_yet';
    case WAITING_FOR_APPROVAL = 'waiting_for_approval';
    case APPROVED = 'approved';
}
