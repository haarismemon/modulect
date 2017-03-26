module UploadHelperSteps
  def upload_csv(csv_text)
    helper.parse_csv_and_display_notice(csv_text, resource_name, resource_header, uploader)
  end

  def expect_creation_attemps(creations)
    expect(flash).not_to be_empty
    expect(flash[:success]).to include pluralize(creations, 'creation')
  end

  def expect_update_attempts(updates)
    expect(flash).not_to be_empty
    expect(flash[:success]).to include pluralize(updates, 'update')
  end

  def expect_no_creation_attempts
    expect(flash[:success]).to include "0 creations"
  end

  def expect_no_update_attempts
    expect(flash[:success]).to include "0 updates"
  end

  def expect_errors
    expect(flash[:error]).not_to be_blank
    clean_errors
  end

  def expect_no_errors
    expect(flash[:error]).to be_blank
  end

  private
  def clean_errors
    flash[:error] = nil
  end
end
