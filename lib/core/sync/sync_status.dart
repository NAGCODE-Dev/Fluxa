class SyncStatus {
  const SyncStatus({
    required this.isAuthenticated,
    required this.isSyncing,
    required this.pendingCount,
    required this.failedCount,
    this.lastError,
    this.lastSyncedAt,
  });

  const SyncStatus.idle()
      : isAuthenticated = false,
        isSyncing = false,
        pendingCount = 0,
        failedCount = 0,
        lastError = null,
        lastSyncedAt = null;

  final bool isAuthenticated;
  final bool isSyncing;
  final int pendingCount;
  final int failedCount;
  final String? lastError;
  final DateTime? lastSyncedAt;

  SyncStatus copyWith({
    bool? isAuthenticated,
    bool? isSyncing,
    int? pendingCount,
    int? failedCount,
    String? lastError,
    DateTime? lastSyncedAt,
  }) {
    return SyncStatus(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      lastError: lastError,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
