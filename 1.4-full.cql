# lagom-persistence-cassandra-core: 1.4.0
# when CassandraReadSide (lagom-scaladsl-persistence-cassandra) is being used:

CREATE TABLE offsetStore (
  eventProcessorId text,
  tag text,
  timeUuidOffset timeuuid,
  sequenceOffset bigint,
  PRIMARY KEY (eventProcessorId, tag)
)


# akka-persistence-cassandra: 0.59
# journal:

CREATE TABLE config (
  property text primary key,
  value text
)

CREATE TABLE metadata (
  persistence_id text PRIMARY KEY,
  deleted_to bigint,
  properties map<text,text>
)

CREATE TABLE messages (
  used boolean static,
  persistence_id text,
  partition_nr bigint,
  sequence_nr bigint,
  timestamp timeuuid,
  timebucket text,
  writer_uuid text,
  ser_id int,
  ser_manifest text,
  event_manifest text,
  event blob,
  meta_ser_id int,
  meta_ser_manifest text,
  meta blob,
  tag1 text,
  tag2 text,
  tag3 text,
  message blob,
  PRIMARY KEY ((persistence_id, partition_nr), sequence_nr, timestamp, timebucket)
)
WITH gc_grace_seconds = 864000
AND compaction = {
  'bucket_high': '1.5',
  'bucket_low': '0.5',
  'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy',
  'enabled': 'true',
  'max_threshold': '32',
  'min_sstable_size': '50',
  'min_threshold': '4',
  'tombstone_compaction_interval': '86400',
  'tombstone_threshold': '0.2',
  'unchecked_tombstone_compaction': 'false'
}

# depends on the number of used tags. The default is one tag.
CREATE MATERIALIZED VIEW eventsbytag1 AS
    SELECT tag1, timebucket, timestamp, persistence_id, partition_nr, sequence_nr, event, event_manifest, message, ser_id, ser_manifest, writer_uuid
    FROM messages
    WHERE persistence_id IS NOT NULL AND partition_nr IS NOT NULL AND sequence_nr IS NOT NULL AND tag1 IS NOT NULL AND timestamp IS NOT NULL AND timebucket IS NOT NULL
    PRIMARY KEY ((tag1, timebucket), timestamp, persistence_id, partition_nr, sequence_nr)
    WITH CLUSTERING ORDER BY (timestamp ASC, persistence_id ASC, partition_nr ASC, sequence_nr ASC)

# akka-persistence-cassandra: 0.59
# snapshot:

CREATE TABLE IF NOT EXISTS snapshots (
  persistence_id text,
  sequence_nr bigint,
  timestamp bigint,
  ser_id int,
  ser_manifest text,
  snapshot_data blob,
  snapshot blob,
  meta_ser_id int,
  meta_ser_manifest text,
  meta blob,
  PRIMARY KEY (persistence_id, sequence_nr)
)
WITH CLUSTERING ORDER BY (sequence_nr DESC)
AND gc_grace_seconds = 864000
AND compaction = {
  'bucket_high': '1.5',
  'bucket_low': '0.5',
  'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy',
  'enabled': 'true',
  'max_threshold': '32',
  'min_sstable_size': '50',
  'min_threshold': '4',
  'tombstone_compaction_interval': '86400',
  'tombstone_threshold': '0.2',
  'unchecked_tombstone_compaction': 'false'
}