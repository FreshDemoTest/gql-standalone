from algoliasearch.search_client import SearchClient
from gqlapi.config import ALGOLIA_APP_ID, ALGOLIA_INDEX_NAME, ALGOLIA_SEARCH_KEY

algolia_client = SearchClient.create(ALGOLIA_APP_ID, ALGOLIA_SEARCH_KEY)
algolia_idx = algolia_client.init_index(ALGOLIA_INDEX_NAME)
