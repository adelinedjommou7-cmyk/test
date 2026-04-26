
// import 'package:example/screens/ressources/core/state/dashboard_state.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DashboardNotifier extends StateNotifier<DashboardState> {
//   final DashboardRepository dashboardRepository;

//   DashboardNotifier(
//     this.dashboardRepository,
//   ) : super(const DashboardState.initial());

//   bool get isFetching =>
//       state.state != DashboardConcreteState.loading &&
//       state.state != DashboardConcreteState.fetchingMore;

//   Future<void> fetchProducts() async {
//     if (isFetching &&
//         state.state != DashboardConcreteState.fetchedAllProducts) {
//       state = state.copyWith(
//         state: state.page > 0
//             ? DashboardConcreteState.fetchingMore
//             : DashboardConcreteState.loading,
//         isLoading: true,
//       );

//       final response = await dashboardRepository.fetchProducts(
//           skip: state.page * 10);

//       updateStateFromResponse(response);
//     } else {
//       state = state.copyWith(
//         state: DashboardConcreteState.fetchedAllProducts,
//         message: 'No more products available',
//         isLoading: false,
//       );
//     }
//   }

//   Future<void> searchProducts(String query) async {
//     if (isFetching &&
//         state.state != DashboardConcreteState.fetchedAllProducts) {
//       state = state.copyWith(
//         state: state.page > 0
//             ? DashboardConcreteState.fetchingMore
//             : DashboardConcreteState.loading,
//         isLoading: true,
//       );

//       final response = await dashboardRepository.searchProducts(
//         skip: state.page * PRODUCTS_PER_PAGE,
//         query: query,
//       );

//       updateStateFromResponse(response);
//     } else {
//       state = state.copyWith(
//         state: DashboardConcreteState.fetchedAllProducts,
//         message: 'No more products available',
//         isLoading: false,
//       );
//     }
//   }

//   void updateStateFromResponse(
//       Either<AppException, PaginatedResponse<dynamic>> response) {
//     response.fold((failure) {
//       state = state.copyWith(
//         state: DashboardConcreteState.failure,
//         message: failure.message,
//         isLoading: false,
//       );
//     }, (data) {
//       final productList = data.data.map((e) => Product.fromJson(e)).toList();

//       final totalProducts = [...state.productList, ...productList];

//       state = state.copyWith(
//         productList: totalProducts,
//         state: totalProducts.length == data.total
//             ? DashboardConcreteState.fetchedAllProducts
//             : DashboardConcreteState.loaded,
//         hasData: true,
//         message: totalProducts.isEmpty ? 'No products found' : '',
//         page: totalProducts.length ~/ PRODUCTS_PER_PAGE,
//         total: data.total,
//         isLoading: false,
//       );
//     });
//   }

//   void resetState() {
//     state = const DashboardState.initial();
//   }
// }
