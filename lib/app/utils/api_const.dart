import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final uuid = supabase.auth.currentUser!.id;

class ApiConst {
  static const coreshema = "core";
  static const translateschema = "translation";
  static const analysisSchema = "analysis";
  static const staticshema = "static";
  static const templatecshema = "templates";
  static const clientShema = "clients";
  static const documentwriter = "templates";
  static const billingShema = "billing";
  static const doctalkShema = "doctalk";
  static const networkShema = "network";
  static const lawyerDeskCheckFile = "http://api.lawyerdesk.ai/general/check_file?file";
  static const gcsFileuploadUrl = "http://api.lawyerdesk.ai/gcs/upload/file";
  static const processclientquery = "http://api.lawyerdesk.ai/process_client_query/";
  static const getReferencesUrl = "http://api.lawyerdesk.ai/chat/references";
  static const chatReady = "http://api.lawyerdesk.ai/chat/ready";
  static String webSoketUrl = "ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/";
  static const docWriterftRefernacesUrl = "http://api.lawyerdesk.ai/draft/references";
  static const docWriterftQuestionUrl = "http://api.lawyerdesk.ai/draft/questions";
  static const finalDraftftQuestionUrl = "http://api.lawyerdesk.ai/draft/write";

  static String apiKey = 'rzp_test_R3dodAqKlWEH1f';
  static String apiSecret = 'lqwRZBuPsjQlKK82Fh2gWC30';
  static String apiUrl = 'https://api.razorpay.com/v1/orders';
}
