

# Collection states

STATE_IDLE = "IDLE"        # request for game list run, need to wait for BGG
STATE_WAITING = "WAITING"  # request for games given enough time, needs checking
STATE_LOADED = "LOADED"    # game list loaded successfully
STATE_FAILED = "FAILED"    # failed to load game list
