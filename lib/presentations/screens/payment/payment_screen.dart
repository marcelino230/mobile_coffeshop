import 'package:caffeshop/component/widget/loader/loader_widget.dart';
import 'package:caffeshop/data/models/request/new_order_body.dart';
import 'package:caffeshop/data/models/request/order_body.dart';
import 'package:caffeshop/data/models/response/payment_list_model.dart';
import 'package:caffeshop/data/utils/dynamic_link.dart';
import 'package:caffeshop/presentations/blocs/cart/delete/delete_all_cart_bloc.dart';
import 'package:caffeshop/presentations/blocs/new_orders/new_orders_bloc.dart';
import 'package:caffeshop/presentations/blocs/order/orders_bloc.dart';
import 'package:caffeshop/presentations/blocs/payment/get_payment.dart';
import 'package:caffeshop/presentations/screens/payment_vendor/gopay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final NewOrderBody newOrderBody;

  const PaymentScreen({Key key, this.newOrderBody}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final NewOrdersBloc ordersBloc = NewOrdersBloc();
  final DeleteAllCartBloc deleteAllCartBloc = DeleteAllCartBloc();

  final DynamicLinkService dynamicLinkService = DynamicLinkService();
  @override
  void initState() {
    super.initState();
    getPaymentBloc.getPayment();
  }

  void orderGopay(String paymentId) async {
    ordersBloc.add(OnNewOrdersEvent(NewOrderBody(
      userId: widget.newOrderBody.userId,
      drinks: widget.newOrderBody.drinks,
      paymentMethodId: paymentId,
      cartId: widget.newOrderBody.cartId,
      total: widget.newOrderBody.total,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getPaymentBloc.getPayment();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NewOrdersBloc>(
            create: (context) => ordersBloc,
          ),
           BlocProvider<DeleteAllCartBloc>(
            create: (context) => deleteAllCartBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<NewOrdersBloc, NewOrdersState>(
                listener: (context, state) {
              if (state is NewOrdersFailure) {
                Get.snackbar(
                  'Gagal',
                  state.message == "Error due to a conflict"
                      ? "Mohon maaf stok belum tersedia"
                      : "Gagal membuat pesanan",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (state is NewOrdersSuccess) {
                Get.snackbar(
                  'Berhasil',
                  "Berhasil membuat pesanan",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Future.delayed(Duration(milliseconds: 1500), () {
                Get.to(GojekPayScreen(
                  uuid: state.response.data.id,
                  number: state.response.data.noTransaction,
                  total: state.response.data.total.toString(),
                ));
                });
              }
            })
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Metode Pembayaran",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Stack(children: [
              StreamBuilder<PeymentMethodList>(
                stream: getPaymentBloc.subject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data.data;
                    if (data.length <= 0) {
                      return Center(
                          child: Text(
                              "Terjadi kesalahan, mohon di refresh kembali"));
                    }
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                onTap: () {
                                  if (data[i].paymentType == 'Gopay') {
                                    orderGopay(data[i].id);
                                  } else {
                                    Get.snackbar(
                                      'Mohon',
                                      "Metode pembayaran ini belum tersedia",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                leading: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    data[i].imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                title: Text(
                                  data[i].paymentType,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  data[i].description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                          );
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              BlocBuilder<NewOrdersBloc, NewOrdersState>(builder: (context, state) {
                if (state is NewOrdersLoading) {
                  return LoaderWidget(title: "Membuat pesanan");
                }
                return const SizedBox.shrink();
              })
            ]),
          ),
        ),
      ),
    );
  }
}
