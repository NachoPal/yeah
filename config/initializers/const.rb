BASE_MARKET = 'BTC'

PERIOD_SEG = 5

#UPDATE_MARKET_CACHE_EACH_X_MIN = 60
TOTAL_MONITORIZE_PERIOD = 5

LENGTH_ARRAY_PRICES = TOTAL_MONITORIZE_PERIOD * 60 / PERIOD_SEG

QUARANTINE_TIME_TO_BUY = 5

NUM_MARKETS_TO_BUY = 1

COMMISSION = 0.25

BTC_QUANTITY_TO_BUY = 0.005

BTC_INITIAL_BALANCE = ((BTC_QUANTITY_TO_BUY * NUM_MARKETS_TO_BUY) + (BTC_QUANTITY_TO_BUY * COMMISSION / 100 * NUM_MARKETS_TO_BUY)).round(8)

THRESHOLD_OF_GAIN = 1.5

SKY_ROCKET_GAIN = 1

SKY_ROCKET_PERIOD_SEG = 60

TREND_THRESHOLD = 0

THRESHOLD_OF_LOST = 10

BUY_ETH_MARKET = false

BUY_BITCNY_MARKET = false

BUY_USDT_MARKET = false

PERCENTILE_VOLUME = 60

GET_RID_OFF_AFTER_MIN = 10

