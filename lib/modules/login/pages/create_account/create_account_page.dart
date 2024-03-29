import 'package:flutter/material.dart';
import 'package:meuapp/modules/login/repositories/login_repositiry_impl.dart';
import 'package:meuapp/modules/login/repositories/login_repository.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button.dart';
import 'package:meuapp/shared/widgets/imput_text/imput_text.dart';
import 'package:validators/validators.dart';
import 'create_account_controller.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late final controller;
  final ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = CreateAccountController(
        repository: LoginRepositoryImpl(database: AppDatabase.instance));
    controller.addListener(() {
      controller.state.When(
          success: (value) => Navigator.pop(context),
          error: (message, _) => ScaffoldKey.currentState!
              .showBottomSheet((context) => BottomSheet(
                  onClosing: () {},
                  builder: (context) => Container(
                        child: Text(message),
                      ))),
          orElse: () {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.colors.background,
          leading: BackButton(color: AppTheme.colors.backButton),
          elevation: 0,
        ),
        backgroundColor: AppTheme.colors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Criando uma conta",
                  style: AppTheme.textStyles.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Mantenha seus gastos em dia",
                  style: AppTheme.textStyles.subtitle,
                ),
                SizedBox(
                  height: 38,
                ),
                InputText(
                  label: "Nome",
                  hint: "Digite seu nome completo",
                  validator: (value) =>
                      value.isNotEmpty ? null : "Digite seu nome completo",
                  onChanged: (value) => controller.onChange(name: value),
                ),
                SizedBox(height: 18),
                InputText(
                  label: "E-mail",
                  hint: "Digite seu e-mail",
                  validator: (value) =>
                      isEmail(value) ? null : "Digite um e-mail válido",
                  onChanged: (value) => controller.onChange(email: value),
                ),
                SizedBox(height: 18),
                InputText(
                  label: "Senha",
                  obscure: true,
                  hint: "Digite sua senha",
                  validator: (value) => value.length >= 8
                      ? null
                      : "Digite uma senha de no mínimo 8 caracteres",
                  onChanged: (value) => controller.onChange(password: value),
                ),
                SizedBox(height: 14),
                AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => controller.state.When(
                          loading: () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                          orElse: () => Button(
                            label: "Criar conta",
                            onTap: () {
                              controller.create();
                            },
                          ),
                        ))
              ],
            ),
          ),
        ));
  }
}
