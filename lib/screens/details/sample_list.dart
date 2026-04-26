import 'package:example/screens/details/test_pdf.dart';
import 'package:flutter/foundation.dart';

/// Contains the output widget of sample
/// appropriate key and output widget mapped
Map<String, Function> getSampleWidget() {
  return <String, Function>{
    // //User Interaction
    // 'chart_with_crosshair': (Key key) => DefaultCrossHair(key),
    // 'selection_modes': (Key key) => DefaultSelection(key),
    // 'selection_index': (Key key) => SelectionIndex(key),
    // 'default_tooltip': (Key key) => DefaultTooltip(key),
    // 'chart_with_trackball': (Key key) => DefaultTrackball(key),
    // 'chart_with_trackball_template': (Key key) => TrackballTemplate(key),
    // 'pinch_zooming': (Key key) => DefaultPanning(key),
    // 'selection_zooming': (Key key) => DefaultZooming(key),
    // 'zooming_with_custom_buttons': (Key key) => ButtonZooming(key),
    // 'tooltip_position': (Key key) => CartesianTooltipPosition(key),
    // 'tooltip_template': (Key key) => TooltipTemplate(key),
    // 'circular_selection': (Key key) => CircularSelection(key),
    // 'circular_dynamic_selection': (Key key) => DynamicCircularSelection(key),
    // 'circular_localization': (Key key) => LocalizationCircularChart(key),
    // 'pie_tooltip_position': (Key key) => PieTooltipPosition(key),
    // 'events': (Key key) => Events(key),
    // 'data_points': (Key key) => DataPoints(key),
    // 'navigate_with_events': (Key key) => NavigationWithEvents(key),
    // 'chart_interactivity': (Key key) => InteractiveChart(key),
    // 'pagination': (Key key) => Pagination(key),
    // 'auto_scrolling': (Key key) => AutoScrollingChart(key),

    // PDF samples
    // 'invoice': (Key key) => InvoicePdf(key),
    // 'certificate': (Key key) => CourseCompletionCertificatePdf(key),
    // 'header_and_footer': (Key key) => HeaderAndFooterPdf(key),
    // 'annotations': (Key key) => AnnotationsPdf(key),
    // 'import_and_export_annotation_data': (Key key) =>
    //     ImportAndExportAnnotationData(key),
    // 'digital_signature': (Key key) => SignPdf(key),
    // 'encryption': (Key key) => EncryptPdf(key),
    // 'form': (Key key) => FormFillingPdf(key),
    // 'import_and_export_form_data': (Key key) => ImportAndExportFormData(key),
    // 'conformance': (Key key) => ConformancePdf(key),
    // 'text_extraction': (Key key) => TextExtractionPdf(key),
    // 'find_text': (Key key) => FindTextPdf(key),

    // PDF Viewer samples
    // 'pdf_viewer_getting_started': (Key key) => GettingStartedPdfViewer(key),
    'pdf_viewer_custom_toolbar': (Key key) => CustomToolbarPdfViewer(key),
    // 'pdf_viewer_annotations': (Key key) => AnnotationsPdfViewer(key),
    // 'pdf_viewer_encrypted': (Key key) => EncryptedPdfViewer(key),
    // 'pdf_viewer_localization': (Key key) => LocalizationPdfViewer(key),
    // 'pdf_viewer_rtl': (Key key) => RTLModePdfViewer(key),
    // 'pdf_viewer_form_filling': (Key key) => FormFillingPdfViewer(key),
  };
}
