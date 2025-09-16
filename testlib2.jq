def more: .next // null;

def pages(fetch): t., ( while(more; fetch) );

def page_items(fetch):
    pages(fetch) | .items[];
    
# Use:
# first_page_json | page_items