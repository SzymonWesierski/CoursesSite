<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250109202550 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE course_draft ADD course_draft_temp_id UUID DEFAULT NULL');
        $this->addSql('COMMENT ON COLUMN course_draft.course_draft_temp_id IS \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE course_draft ADD CONSTRAINT FK_AFD7917C75AB8617 FOREIGN KEY (course_draft_temp_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_AFD7917C75AB8617 ON course_draft (course_draft_temp_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE course_draft DROP CONSTRAINT FK_AFD7917C75AB8617');
        $this->addSql('DROP INDEX UNIQ_AFD7917C75AB8617');
        $this->addSql('ALTER TABLE course_draft DROP course_draft_temp_id');
    }
}
