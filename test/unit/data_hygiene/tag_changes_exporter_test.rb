require "test_helper"
require "data_hygiene/tag_changes_exporter"

class TagChangesExporterTest < ActiveSupport::TestCase
  include DataHygiene

  def setup
    @csv_location = "/tmp/test.csv"
    @topic_id_to_add = "the-new-topic"
    @topic_id_to_remove = "the-old-topic"
    @publication = create :publication, :published, primary_specialist_sector_tag: @topic_id_to_remove
    @second_publication = create :publication, :published, primary_specialist_sector_tag: @topic_id_to_remove
    @third_publication = create :publication, :published, primary_specialist_sector_tag: @topic_id_to_add
  end

  test "#export - exports the tag changes to make in CSV format" do
    TagChangesExporter.new(@csv_location, @topic_id_to_add, @topic_id_to_remove).export

    assert_equal expected_parsed_export, parsed_export
  end

  def expected_parsed_export
    [
      {
        "id" => @publication.id.to_s,
        "type" => @publication.type,
        "slug" => @publication.slug,
        "add_topic" => "the-new-topic",
        "remove_topic" => "the-old-topic"
      },
      {
        "id" => @second_publication.id.to_s,
        "type" => @second_publication.type,
        "slug" => @second_publication.slug,
        "add_topic" => "the-new-topic",
        "remove_topic" => "the-old-topic"
      }
    ]
  end

  def parsed_export
    parsed = []
    CSV.foreach(@csv_location, headers: true) do |data|
      parsed << data.to_hash
    end
    parsed
  end
end