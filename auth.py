import spotipy
from spotipy.oauth2 import SpotifyOAuth
import os

SPOTIPY_CLIENT_SECRET='8249ac0021eb440d858d1dbc6717a811'
SPOTIPY_CLIENT_ID='81a9b3f937fc4430a1cf42210e2439bb'
SPOTIPY_REDIRECT_URI='https://spotif-l-y.herokuapp.com/redirect'
#set spotipy envirnoment variables
os.environ['SPOTIPY_CLIENT_ID'] = SPOTIPY_CLIENT_ID
os.environ['SPOTIPY_CLIENT_SECRET'] = SPOTIPY_CLIENT_SECRET
os.environ['SPOTIPY_REDIRECT_URI'] = SPOTIPY_REDIRECT_URI

scope = "user-library-read"

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope, open_browser=False))
print(sp.me())
# results = sp.current_user_saved_tracks()
# for idx, item in enumerate(results['items']):
#     track = item['track']
#     print(idx, track['artists'][0]['name'], " – ", track['name'])