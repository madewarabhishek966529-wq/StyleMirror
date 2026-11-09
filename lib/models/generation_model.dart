/// Status of an AI try-on generation job
enum GenerationStatus {
  queued,
  running,
  done,
  failed,
}

/// Generation job details
class GenerationJob {
  final String id;
  final String photoId;
  final String? hairStyleId;
  final String? beardStyleId;
  final String view;
  final GenerationStatus status;
  final String? resultUrl;
  final String? resultBase64;
  final double? identityScore;
  final int? latencyMs;
  final String? error;
  final DateTime createdAt;

  GenerationJob({
    required this.id,
    required this.photoId,
    this.hairStyleId,
    this.beardStyleId,
    this.view = 'front',
    required this.status,
    this.resultUrl,
    this.resultBase64,
    this.identityScore,
    this.latencyMs,
    this.error,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isDone => status == GenerationStatus.done;
  bool get isFailed => status == GenerationStatus.failed;
  bool get isProcessing => status == GenerationStatus.queued || status == GenerationStatus.running;

  factory GenerationJob.fromJson(Map<String, dynamic> json) {
    GenerationStatus parseStatus(String? statusStr) {
      switch (statusStr?.toLowerCase()) {
        case 'done':
          return GenerationStatus.done;
        case 'failed':
          return GenerationStatus.failed;
        case 'running':
          return GenerationStatus.running;
        case 'queued':
        default:
          return GenerationStatus.queued;
      }
    }

    return GenerationJob(
      id: json['id'] as String? ?? json['job_id'] as String? ?? '',
      photoId: json['photo_id'] as String? ?? '',
      hairStyleId: json['hair_style_id'] as String?,
      beardStyleId: json['beard_style_id'] as String?,
      view: json['view'] as String? ?? 'front',
      status: parseStatus(json['status'] as String?),
      resultUrl: json['result_url'] as String?,
      resultBase64: json['result_base64'] as String?,
      identityScore: (json['identity_score'] as num?)?.toDouble(),
      latencyMs: (json['latency_ms'] as num?)?.toInt(),
      error: json['error'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_id': photoId,
      'hair_style_id': hairStyleId,
      'beard_style_id': beardStyleId,
      'view': view,
      'status': status.name,
      'result_url': resultUrl,
      if (resultBase64 != null) 'result_base64': resultBase64,
      'identity_score': identityScore,
      'latency_ms': latencyMs,
      'error': error,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
