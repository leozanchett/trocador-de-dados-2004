# Trocador de dados 2004
 Sistema de gerenciamento de troca, exclusão e compressão de banco de dados e arquivos. Desenvolvido utilizando padrões SOLID e Strategy.

A principal utilidade se dá pela facilidade de trocar bancos de dados firebird através de grid dinâmico.

![Screenshot_1](https://user-images.githubusercontent.com/45577227/126082667-caba1ea2-082b-42a5-aecb-8d4450bc9f42.png)

Tela inicial do sistema, onde é apresentado a chave da empresa, razão social, nome do arquivo e tamanho do mesmo. A soma total dos bytes é levado em consideração pelos arquivos em si, exemplo: se observar o _DADOS.FDB repete por conta que o .FDB contém duas empresas em sua base de dados, com razões sociais distintas, porém o cálculo de bytes do mesmo não é efetuado duas vezes, por se tratar do mesmo arquivo.

![Screenshot_2](https://user-images.githubusercontent.com/45577227/126082677-8fafaadd-9f1b-4048-81ed-c6f015208cd2.png)

Ao alterar a exibição de arquivos, é apresentado os arquivos distintos que estão no diretório, quais são possível a compressão e exclusão.

![Screenshot_4](https://user-images.githubusercontent.com/45577227/126078971-e893f48d-14ed-4276-9f1f-45bbcaab76b6.png)

Por fim a tela de configuração com o banco onde é solicitado apenas usuário e senha, atualmente disponível apenas para Firebird.
