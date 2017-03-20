module SelectizeSelect
  # waits for the text to show up in autocomplete and then selects it
  def selectize_select(text)
   find(".selectize-input input", match: :first).native.send_keys("#{text}\n")
  end
end
