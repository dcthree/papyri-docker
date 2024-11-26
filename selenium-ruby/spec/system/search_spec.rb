# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Seach Page Tests", type: :system do
  it "should go to homepage and test page title" do
    visit '/search'
    expect(page).to have_title('PN Search')
  end

  # capybara prevents animations from happening but this can be toggled
  it "clicks #search-toggle and checks that search input pane is hidden" do
    visit '/search'
    search_toggle = page.find('#search-toggle')
    expect(search_toggle['class']).to match /toggle-open/
    page.execute_script("document.getElementById('search-toggle').click()")
    sleep 2 # sleep covers the time it takes for the animation to complete
    expect(search_toggle['class']).to match /toggle-closed/
    pane_css = page.find(:css, '#vals-and-records-wrapper')
    expect(pane_css.native.style('position')).to eq('relative')
    expect(pane_css.native.style('left')).to eq('0px')
  end

  it "search query options with no_caps no_marks text" do
    visit '/search?STRING=(test)&no_caps=on&no_marks=on&target=text&DATE_MODE=LOOSE&DOCS_PER_PAGE=15'
    within('#prev-constraint-string1') do
      label = find('div.constraint-label')
      expect(label).to have_text(/Substring: test/)
      expect(label).to have_text(/Target: text/)
      expect(label).to have_text(/No Caps: On/)
      expect(label).to have_text(/No Marks: On/)
    end
    expect(page).to have_css('#DOCS_PER_PAGE[value="15"]')
  end

  it "search query options with metadata target" do
    visit '/search?STRING=(test2)&no_caps=off&no_marks=off&target=metadata&DATE_MODE=LOOSE&DOCS_PER_PAGE=30'
    within('#prev-constraint-string1') do
      label = find('div.constraint-label')
      expect(label).to have_text(/Phrase: test2/)
      expect(label).to have_text(/Target: metadata/)
    end
    expect(page).to have_css('#DOCS_PER_PAGE[value="30"]')
  end

  it "search query options with translation target" do
    visit '/search?STRING=(test2)&no_caps=off&no_marks=off&target=translation&DATE_MODE=LOOSE&DOCS_PER_PAGE=30'
    within('#prev-constraint-string1') do
      label = find('div.constraint-label')
      expect(label).to have_text(/Phrase: test/)
      expect(label).to have_text(/Target: translation/)
    end
    expect(page).to have_css('#DOCS_PER_PAGE[value="30"]')
  end

  it "select series options" do
    visit '/search'
    # combobox content is lazy loaded so prime the combobox
    execute_script("$('#series-wrapper a.ui-corner-right').trigger('click')")
    execute_script("$('.ui-autocomplete div.ui-menu-item-wrapper:contains(\\'HGV: BGU\\')').trigger('click')")
    sleep 2
    expect(current_url).to include("SERIES=hgv%3ABGU")
    within('#prev-constraint-identifier') do
      label = find('div.constraint-label')
      expect(label).to have_text(/SERIES: hgv:BGU/)
    end
  end

  it "select collection options" do
    visit '/search'
    # combobox content is lazy loaded so prime the combobox
    execute_script("$('#collection-wrapper a.ui-corner-right').trigger('click')")
    execute_script("$('.ui-autocomplete div.ui-menu-item-wrapper:contains(\\'berkeley\\')').trigger('click')")
    sleep 2
    expect(current_url).to include("COLLECTION=berkeley")
    within('#prev-constraint-identifier') do
      label = find('div.constraint-label')
      expect(label).to have_text(/COLLECTION: berkeley/)
    end
  end

  context 'author search options' do

    before {
      visit '/search'
      # combobox content is lazy loaded so prime the combobox
      execute_script("$('#author-selector a.ui-corner-right').trigger('click')")
      execute_script("$('.ui-autocomplete div.ui-menu-item-wrapper:contains(\\'Homerus\\')').trigger('click')")
      sleep 2
    }
    
    it "select author options" do 
      expect(current_url).to include("AUTHOR=Homerus")
      within('#prev-constraint-author') do
        label = find('div.constraint-label')
        expect(label).to have_text(/Author: Homerus/)
      end
    end

    # Based on pre-loaded test data from USE_SOLR_BACKUPS=true
    it 'tests further restricted select options' do 
      # expect(page).to have_css("#work-selector input.ui-widget[value^='Vita Constantini' i]")
      within('#work-selector') do 
        expect(find('input.ui-widget').value).to match(/Ilias/)
      end
      
      within('#place-selector') do 
        expect(find('input.ui-widget').value).to match(/Karanis/)
      end

      within('#nome-selector') do
        expect(find('input.ui-widget').value).to match(/Arsinoites/)
      end

      within('#date-start-selector') do
        expect(find('input.ui-widget').value).to match(/200 CE/)
      end

      within('#date-end-selector') do
        expect(find('input.ui-widget').value).to match(/250 CE/)
      end

      within('#lang-selector') do
        expect(find('input.ui-widget').value).to match(/Ancient Greek/)
      end

      within('#transl-selector') do
        expect(find('input.ui-widget').value).to match(/English/)
      end
    end
  end

end