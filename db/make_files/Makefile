DB=pg_ar_deep_dive_development
BUILD=${CURDIR}/../scripts/build.sql
SCRIPTS=${CURDIR}/../scripts
CSV='${CURDIR}/../seed_data/import_data.csv'
MASTER=$(SCRIPTS)/import.sql
NORMALIZE = $(SCRIPTS)/normalize.sql

all: normalize
	psql $(DB) -f $(BUILD)

master:
	@cat $(MASTER) >> $(BUILD)

import: master
	@echo "COPY imported_data_master FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

normalize: import
	@cat $(NORMALIZE) >> $(BUILD)

clean:
	@rm -rf $(BUILD)
