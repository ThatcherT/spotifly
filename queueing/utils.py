import random


def queue_50_songs(sp, listener):
    for i in range(50):
        # init empty list to queue next song
        song = []
        while song == []:
            random_offset = random.randint(0, listener.max_offset) # get a random song between 0 and current known max offset
            results = sp.current_user_saved_tracks(limit=1, offset=random_offset)
            song = list(results['items'])
            if song == []:
                # max_offset is too high rebase it at one under current random offset
                listener.max_offset = random_offset - 1
                listener.save()
            else:
                # iterate through lst
                for item in song:
                    # get uri of songs
                    uri = item['track']['uri']
                    # queue each song
                    sp.add_to_queue(uri, device_id=None)