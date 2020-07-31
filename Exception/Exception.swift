//
//  Exception.swift
//  Exception
//
//  Created by i on 2020/7/29.
//  Copyright © 2020 xlsn0w. All rights reserved.
//

import UIKit

class Exception: NSObject {
//    别人的错，不需要愤怒，因为愤怒是拿他的错误惩罚自己
//    自己的错，不必要愤怒，你需要的是反思和改进提高自己
}

/*
 
 了解和分析应用程序崩溃报告
 技术说明TN2151
 了解和分析应用程序崩溃报告
 当应用程序崩溃时，将创建崩溃报告，这对于理解导致崩溃的原因非常有用。本文档包含有关如何符号化，理解和解释崩溃报告的基本信息。

 介绍
 当应用程序崩溃时，将创建崩溃报告并将其存储在设备上。崩溃报告描述了应用程序终止的条件，在大多数情况下，这些条件包括每个执行线程的完整回溯，通常对于调试应用程序中的问题非常有用。您应该查看这些崩溃报告，以了解应用程序崩溃的原因，然后尝试修复它们。

 带有回溯的崩溃报告需要先进行符号化才能进行分析。符号化将存储器地址替换为易于理解的函数名称和行号。如果您通过Xcode的“设备”窗口从设备上注销崩溃日志，那么几秒钟后它们将自动为您表示。否则，您需要.crash通过将其导入Xcode Devices窗口来自己对文件进行符号化。有关详细信息，请参见符号化崩溃报告。

 一个低内存报告从其他的崩溃报告不同之处在于有这类型的报告没有回溯。当发生内存不足崩溃时，您必须调查内存使用模式以及对内存不足警告的响应。本文档为您指出了一些可能有用的内存管理参考。

 获取崩溃和内存不足报告
 调试已部署的iOS应用程序讨论了如何直接从iOS设备检索崩溃和内存不足报告。

 《 App Distribution Guide 》中的“分析崩溃报告”讨论了如何查看从TestFlight beta测试人员和从App Store下载了您的应用程序的用户收集的汇总崩溃报告。

 回到顶部
 象征崩溃报告
 符号化是将回溯地址解析为源代码方法或函数名称（称为符号）的过程。如果不首先表示崩溃报告，则很难确定崩溃发生的位置。

 注意：“  低内存报告”不需要符号化。

 注意：  macOS的崩溃报告在生成时通常被符号化或部分符号化。本节着重于用符号表示来自iOS，watchOS和tvOS的崩溃报告，但是对于macOS来说，整个过程是相似的。

 图1   崩溃报告和符号化过程概述。

 当编译器将您的源代码转换成机器代码时，它还会生成调试符号，这些调试符号将已编译二进制文件中的每条机器指令映射回其源代码行。根据调试信息格式（DEBUG_INFORMATION_FORMAT）的构建设置，这些调试符号将存储在二进制文件中或随附的调试符号（dSYM）文件中。默认情况下，应用程序的调试版本将调试符号存储在已编译的二进制文件中，而应用程序的发布版本将调试符号存储在配套dSYM文件中以减小二进制文件的大小。
 调试符号文件和应用程序二进制文件通过构建UUID在每个构建基础上捆绑在一起。将为您的应用程序的每个内部版本生成一个新的UUID，并唯一标识该内部版本。即使使用相同的编译器设置从相同的源代码重建功能相同的可执行文件，它也将具有不同的构建UUID。来自后续版本的调试符号文件，即使来自相同的源文件，也不会与其他版本的二进制文件互操作。

 当您存档应用程序以进行分发时，Xcode将与一起收集应用程序二进制文件。dSYM文件并将其存储在主文件夹内的某个位置。您可以在Xcode Organizer的“ Archived”部分下找到所有已存档的应用程序。有关创建档案的更多信息，请参阅《App分发指南》。
 重要提示：  要符号化测试人员，应用程序审查和客户的崩溃报告，必须为分发的应用程序的每个内部版本保留存档。

 如果要通过App Store分发应用程序，或使用Test Flight进行Beta测试，则可以选择dSYM在将存档上传到iTunes Connect时包括文件。在提交对话框中，选中“包括您的应用程序的应用程序符号...”。dSYM要接收从TestFlight用户和选择共享诊断数据的客户收集的崩溃报告，必须上传文件。有关崩溃报告服务的更多信息，请参阅《App分发指南》。
 重要提示：  从应用程序审查收到的崩溃报告会unsymbolicated，即使你包括dSYM上传您的档案到iTunes Connect的情况下的文件。您将需要使用Xcode象征从App Review收到的任何崩溃报告。请参阅使用Xcode象征iOS崩溃报告。

 当您的应用程序崩溃时，会创建一个非符号化的崩溃报告并将其存储在设备上。
 用户可以按照Debugging Deployed iOS Apps中的步骤直接从其设备检索崩溃报告。如果您已经通过AdHoc或Enterprise发行版分发了应用程序，则这是从用户那里获取崩溃报告的唯一方法。
 从设备中检索到的崩溃报告没有符号化，需要使用Xcode进行符号化。Xcode使用dSYM与您的应用程序二进制文件关联的文件，将回溯中的每个地址替换为其源代码中的原始位置。结果是一个符号化的崩溃报告。
 如果用户选择与Apple共享诊断数据，或者用户已通过TestFlight安装了应用程序的Beta版，则崩溃报告将上传到App Store。
 App Store象征着崩溃报告，并将其与类似的崩溃报告进行分组。这种相似的崩溃报告的汇总称为崩溃点。
 在Xcode的崩溃管理器中可以使用带符号的崩溃报告。
 位码
 位码是已编译程序的中间表示。当您存档启用了位码的应用程序时，编译器会生成包含位码而不是机器码的二进制文件。二进制文件上传到App Store后，该位代码将被编译为机器代码。App Store将来可能会再次编译位代码，以利用将来对编译器的改进，而无需您采取任何措施。

 图2位   代码编译过程概述。

 由于二进制文件的最终编译是在App Store上进行的，因此您的Mac将不包含符号化dSYM从App Review或从其设备发送了崩溃报告的用户收到的崩溃报告所需的调试符号（）文件。尽管dSYM在归档应用程序时会生成一个文件，但该文件是用于二进制代码的，不能用于表示崩溃报告。App Store可以dSYM从Xcode或iTunes Connect网站上下载位码编译过程中生成的文件。您必须下载这些dSYM文件，以表示从App Review或从其设备向您发送崩溃报告的用户收到的崩溃报告。通过崩溃报告服务收到的崩溃报告将自动被符号化。

 重要提示：  由App Store编译的二进制文件将具有与最初提交的二进制文件不同的UUID。

 从Xcode下载dSYM文件
 在档案组织者中，选择最初提交给App Store的档案。
 单击下载dSYMs按钮。
 Xcode下载dSYM文件并将其插入到选定的档案中。

 从iTunes Connect网站下载dSYM文件
 打开“应用程序详细信息”页面。
 单击活动。
 从“所有版本”列表中，选择一个版本。
 单击下载dSYM链接。
 将“隐藏”符号名称转换回其原始名称
 将带有位码的应用程序上载到App Store时，可以通过取消选中“提交”对话框中的“上载应用程序的符号以从Apple接收符号报告”来选择不发送应用程序的符号。如果您选择不将应用程序的符号信息发送给Apple，则Xcode将替换应用程序中的符号。dSYM将应用程序发送到iTunes Connect之前，请使用带有混淆符号（例如“ __hidden＃109_”）的文件。Xcode在原始符号和“隐藏”符号之间创建映射，并将此映射存储.bcsymbolmap在应用程序归档文件内的文件中。每个。dSYM文件将有一个对应的.bcsymbolmap文件。

 在符号化崩溃报告之前，您需要对上的符号进行模糊处理。dSYM从iTunes Connect下载的文件。如果您使用Xcode中的“下载dSYMs”按钮，则将自动为您执行这种模糊处理。但是，如果您使用iTunes Connect网站下载。dSYM文件，打开终端并使用以下命令对符号进行模糊处理（将示例路径替换为您自己的存档和从iTunes Connect下载的dSYMs文件夹）：

 xcrun dsymutil -symbol-map〜/ Library / Developer / Xcode / Archives / 2017-11-23 / MyGreatApp \ 11-23-17 \，\ 12.00 \ PM.xcarchive / BCSymbolMaps〜/ Downloads / dSYMs / 3B15C133-88AA-35B0 -B8BA-84AF76826CE0.dSYM
 对每个运行此命令。dSYM您下载的dSYMs文件夹中的文件。

 确定故障报告是否带有符号
 崩溃报告可能没有符号化，完全符号化或部分符号化。未符号化的崩溃报告将在backtrace中不包含方法或函数名称。而是在加载的二进制映像中具有可执行代码的十六进制地址。在完全符号化的崩溃报告中，回溯的每一行中的十六进制地址将替换为相应的符号。在部分符号化的崩溃报告中，仅回溯中的某些地址已被其相应的符号替换。

 显然，您应该尝试完全符号化您收到的任何崩溃报告，因为它将提供有关崩溃的最深刻见解。部分符号化的崩溃报告可能包含足够的信息来理解崩溃，这取决于崩溃的类型以及回溯的哪些部分已被成功符号化。非符号化的崩溃报告很少有用。

 图3   在不同符号级别的相同回溯。

 使用Xcode象征iOS崩溃报告
 Xcode将自动尝试用符号表示它遇到的所有崩溃报告。您只需要做的就是将崩溃报告添加到Xcode Organizer。

 注意：  如果没有.crash扩展名，Xcode将不接受崩溃报告。如果您收到的崩溃报告中没有扩展名或具有.txt扩展名，请.crash按照以下步骤将其重命名为具有扩展名。

 将iOS设备连接到Mac
 从“窗口”菜单中选择“设备”
 在左列的“设备”部分下，选择一个设备
 单击右侧面板“设备信息”部分下的“查看设备日志”按钮
 将您的崩溃报告拖到显示面板的左列
 Xcode将自动符号化崩溃报告并显示结果
 为了表示崩溃报告，Xcode需要能够找到以下内容：

 崩溃的应用程序的二进制dSYM文件和文件。
 dSYM应用程序链接到的所有自定义框架的二进制文件和文件。对于使用应用程序从源构建的框架，其dSYM文件将与应用程序的dSYM文件一起复制到存档中。对于由第三方构建的框架，您将需要向作者索要dSYM文件。
 崩溃时正在运行该应用程序的操作系统的符号。这些符号包含特定OS版本（例如iOS 9.3.3）中包含的框架的调试信息。操作系统符号是特定于体系结构的-适用于64位设备的iOS版本不会包含armv7符号。Xcode将自动从您连接到Mac的每个设备中复制OS符号。
 如果缺少这些，则Xcode可能无法符号化崩溃报告，或者只能部分符号化崩溃报告。

 使用atos象征崩溃报告
 的 阿托斯命令将数字地址转换为其符号等效项。如果完整的调试符号信息可用，则输出atos将包括文件名和源行号信息。该atos命令可用于符号化未符号化或部分符号化的崩溃报告的回溯中的各个地址。使用atos以下符号表示崩溃报告的一部分：

 在回溯中找到要符号化的线。在第二列中注意二进制映像的名称，在第三列中注意地址。
 在崩溃报告底部的二进制图像列表中查找具有该名称的二进制图像。注意二进制映像的体系结构和加载地址。
 图4   崩溃报告中需要使用的信息atos。

 找到dSYM二进制文件。您可以使用Spotlight查找dSYM二进制图像的UUID 的匹配文件。请参阅“ 符号故障排除”部分。dSYM文件是捆绑软件，其中包含一个文件，其中包含编译器在构建时生成的DWARF调试信息。dSYM调用时，必须提供此文件的路径，而不是束的路径atos。
 通过以上信息，您可以使用atos命令在回溯中用符号表示地址。您可以指定多个符号地址，以空格分隔。
 atos -arch <Binary Architecture> -o <Path to dSYM file>/Contents/Resources/DWARF/<binary image name> -l <load address> <address to symbolicate>

 清单1atos遵循上述步骤  的命令用法示例以及结果输出。

 $ atos -arch arm64 -o TheElements.app.dSYM / Contents / Resources / DWARF / TheElements -l 0x1000e4000 0x00000001000effdc
 -[AtomicElementViewController myTransitionDidStop：完成：上下文：]
 符号故障排除
 如果Xcode无法完全表示崩溃报告，则可能是因为Mac缺少dSYM应用程序二进制dSYM文件，应用程序链接到的一个或多个框架的文件，或应用程序运行时所用操作系统的设备符号它崩溃了。以下步骤显示了如何使用Spotlight确定dSYM在二进制映像中是否需要用符号表示回溯地址的文件。

 图5   找到二进制图像的UUID。

 在回溯中找到Xcode无法符号化的行。在第二列中注意二进制映像的名称。
 在崩溃报告底部的二进制图像列表中查找具有该名称的二进制图像。该列表包含崩溃时加载到进程中的每个二进制映像的UUID。

 清单2   您可以使用grep命令行工具在二进制图像列表中快速找到条目。
 $ grep --after-context = 1000“二进制图像：” <崩溃报告的路径> | grep <二进制名称>
 将二进制图像的UUID转换为以8-4-4-4-12（XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX）组分隔的32个字符串。请注意，所有字母都必须大写。
 mdfind使用查询使用命令行工具搜索UUID "com_apple_xcode_dsym_uuids == <UUID>"（包括引号）。

 清单3   使用mdfind命令行工具搜索dSYM具有给定UUID的文件。
 $ mdfind“ com_apple_xcode_dsym_uuids == <UUID>”
 如果Spotlight找到dSYM用于UUID 的文件，mdfind则将打印该dSYM文件的路径以及可能包含其存档的路径。如果dSYM找不到用于UUID 的文件， mdfind将退出而不打印任何内容。
 如果Spotlight找到了dSYM二进制文件，但是Xcode无法在该二进制映像中符号化地址，那么您应该提交错误。将崩溃报告和相关dSYM文件附加到错误报告。解决方法是，您可以使用手动标记地址atos。请参阅使用atos象征崩溃报告。

 如果Spotlight找不到dSYM二进制映像的，请确认您仍然具有崩溃的应用程序版本的Xcode归档文件，并且该归档文件位于Spotlight可以找到它的某个位置（主目录中的任何位置都可以）。如果您的应用程序是在启用了位码的情况下构建的，请确保dSYM已从App Store 下载了用于最终编译的文件。请参阅从Xcode下载dSYM文件。

 如果您认为dSYM二进制映像是正确的，则可以使用dwarfdump命令来打印匹配的UUID。您也可以使用该dwarfdump命令来打印二进制文件的UUID。

 xcrun dwarfdump --uuid <Path to dSYM file>

 注意：  您必须拥有最初提交给App Store的崩溃应用程序版本的存档。的dSYM文件和应用程序二进制每个累积的基础上具体绑在一起。即使使用相同的来源和构建配置来创建新的存档，也不会生成dSYM可以与崩溃的构建进行互操作的文件。

 如果您不再拥有此存档，则应提交保留该存档的应用程序的新版本。然后，您将可以使用符号表示此新版本的崩溃报告。

 回到顶部
 分析崩溃报告
 本部分讨论在标准崩溃报告中找到的每个部分。

 标头
 每个崩溃报告都以标题开头。

 清单4   崩溃报告中标头的节选。

 事件标识符：B6FD1E8E-B39F-430B-ADDE-FC3A45ED368C
 CrashReporter密钥：f04e68ec62d3c66057628c9ba9839e30d55937dc
 硬件型号：iPad6,8
 工艺：TheElements [303]
 路径：/private/var/containers/Bundle/Application/888C1FA2-3666-4AE2-9E8E-62E2F787DEC1/TheElements.app/TheElements
 标识符：com.example.apple-samplecode.TheElements
 版本：1.12
 代码类型：ARM-64（本机）
 角色：前台
 父流程：已启动[1]
 联盟：com.example.apple-samplecode.TheElements [402]
  
 日期/时间：2016-08-22 10：43：07.5806 -0700
 发布时间：2016-08-22 10：43：01.0293 -0700
 作业系统版本：iPhone OS 10.0（14A5345a）
 报告版本：104
 大多数字段是不言自明的，但有些字段值得特别注意：

 事件标识符：报告的唯一标识符。两个报告永远不会共享相同的事件标识符。
 CrashReporter密钥：每个设备的匿名标识符。来自同一设备的两个报告将包含相同的值。
 Beta标识符：崩溃的应用程序的设备和供应商的组合的唯一标识符。来自同一供应商和同一设备的两个应用程序报告将包含相同的值。该字段仅出现在为通过TestFlight分发的应用程序生成的崩溃报告中，并替换了CrashReporter Key字段。
 进程：崩溃的进程的可执行文件名。这与CFBundleExecutable应用程序的信息属性列表中键的值匹配。
 版本：崩溃的进程的版本。该字段的值是崩溃的应用程序的CFBundleVersion和的串联CFBundleVersionString。
 代码类型：崩溃的进程的目标体系结构。这将是一ARM-64，ARM，x86-64，或x86。
 作用：终止时分配给进程的task_role。
 操作系统版本：发生崩溃的操作系统版本，包括内部版本号。
 异常信息
 不要与Objective-C / C ++异常混淆（尽管其中一种可能是崩溃的原因），本节列出了Mach 异常类型和相关字段，它们提供了有关崩溃性质的信息。并非所有字段都会出现在每个崩溃报告中。

 清单5   摘自Exception Codes部分的摘录，该崩溃报告是由于未捕获的Objective-C异常而导致进程终止时生成的崩溃报告。

 异常类型：EXC_CRASH（SIGABRT）
 异常代码：0x0000000000000000、0x0000000000000000
 异常说明：EXC_CORPSE_NOTIFY
 线程触发：0
 清单6   摘自流程终止报告，该报表是由于进程取消引用NULL指针而导致的崩溃报告。

 异常类型：EXC_BAD_ACCESS（SIGSEGV）
 异常子类型：KERN_INVALID_ADDRESS位于0x0000000000000000
 终止信号：分段故障：11
 终止原因：命名空间SIGNAL，代码0xb
 终止过程：排除处理程序[0]
 线程触发：0
 下面介绍了此部分中可能出现的字段。

 异常代码：处理器特定的有关异常的信息，编码为一个或多个64位十六进制数字。通常，此字段将不存在，因为Crash Reporter解析异常代码以将其作为其他字段中的人类可读描述来呈现。
 异常子类型：异常代码的人类可读名称。
 异常消息：从异常代码中提取的其他人类可读信息。
 异常说明：并非特定于一种异常类型的其他信息。如果包含该字段，SIMULATED (this is NOT a crash)则该进程不会崩溃，但应系统（通常是看门狗）的请求而终止。
 终止原因：进程终止时指定的退出原因信息。进程内部和外部的关键系统组件都会在遇到致命错误（例如，错误的代码签名，缺少的依赖库或没有适当权利的情况下访问隐私敏感信息）时终止进程。macOS Sierra，iOS 10，watchOS 3和tvOS 10已采用新的基础结构来记录这些错误，并且由这些操作系统生成的崩溃报告在“终止原因”字段中列出了错误消息。
 由Thread触发：引发异常的线程。
 以下各节介绍了一些最常见的异常类型：

 错误的内存访问[EXC_BAD_ACCESS // SIGSEGV // SIGBUS]
 该进程尝试访问无效的内存，或者尝试以内存保护级别不允许的方式访问内存（例如，写入只读内存）。“ 异常子类型”字段包含kern_return_t描述错误和被错误访问的内存地址。

 以下是一些调试错误的内存访问崩溃的提示：

 如果objc_msgSend或在崩溃线程objc_release的Backtrace顶部附近，则该进程可能已尝试向已释放对象发送消息。您应该使用Zombies仪器来分析应用程序，以更好地了解此崩溃的情况。
 如果在崩溃线程gpus_ReturnNotPermittedKillClient的Backtraces顶部附近，则该进程被终止，因为该进程试图在后台使用OpenGL ES或Metal进行渲染。请参阅QA1766：移至后台时如何修复OpenGL ES应用程序崩溃。
 在启用了地址清理程序的情况下运行您的应用程序。地址清理器在编译后的代码中为内存访问添加了其他工具。当您的应用程序运行时，Xcode会警告您是否以可能导致崩溃的方式访问内存。
 异常退出[EXC_CRASH // SIGABRT]
 该过程异常退出。这种异常类型导致崩溃的最常见原因是未捕获的Objective-C / C ++ 异常和对的调用abort()。

 如果扩展程序花费太多时间进行初始化（监视程序终止），则该扩展程序将以这种异常类型终止。如果某个扩展由于启动时挂起而被杀死，则生成的崩溃报告的Exception Subtype将为LAUNCH_HANG。因为扩展没有main功能，所以花在初始化上的任何时间都会在+load扩展和从属库中的静态构造函数和方法中发生。您应该尽可能多地推迟这项工作。

 跟踪陷阱[EXC_BREAKPOINT // SIGTRAP]
 与异常退出类似，此异常旨在使附加的调试器有机会在执行的特定点中断进程。您可以使用该__builtin_trap()函数从自己的代码中触发此异常。如果未连接调试器，则过程终止，并生成崩溃报告。

 遇到致命错误时，较低级的库（例如libdispatch）将捕获该进程。可以在崩溃报告的“ 其他诊断信息”部分或设备的控制台中找到有关该错误的其他信息。

 如果在运行时遇到意外情况，则Swift代码将以此异常类型终止，例如：

 值为nil的非可选类型
 强制类型转换失败
 查看回溯以确定在哪里遇到意外情况。其他信息也可能已记录到设备的控制台中。您应该在崩溃位置修改代码以妥善处理运行时故障。例如，使用“ 可选绑定”而不是强制展开可选对象。

 非法指令[EXC_BAD_INSTRUCTION // SIGILL]
 进程试图执行非法或未定义的指令。该过程可能试图通过配置错误的函数指针跳到无效地址。

 在Intel处理器上，ud2操作码会导致EXC_BAD_INSTRUCTION异常，但通常用于捕获进程以进行调试。如果在运行时遇到意外情况，则英特尔处理器上的Swift代码将以此异常类型终止。有关详细信息，请参见跟踪陷阱。

 退出[SIGQUIT]
 该进程是在另一个具有管理其生存期权限的进程的请求下终止的。SIGQUIT这并不意味着该过程已崩溃，但是它确实有可能以可检测的方式发生错误。

 在iOS上，如果加载时间太长，主机应用将退出键盘扩展。崩溃报告中显示的Backtrace不太可能指向负责的代码。最有可能的是，扩展的启动路径上的其他一些代码花了很长时间才能完成，但在时间限制之前完成了，并且在退出扩展时，执行移至了Backtraces中显示的代码上。您应该对扩展进行概要分析，以更好地了解启动期间大部分工作的发生位置，并将该工作移至后台线程或将其推迟到以后（加载扩展后）。

 被杀[SIGKILL]
 该过程应系统的要求终止。查看终止原因字段，以更好地了解终止原因。

 该终止原因字段将包含一个名称空间，然后一个代码。以下代码特定于watchOS：

 终止代码0xc51bad01表示监视应用程序已终止，因为它在执行后台任务时占用了过多的CPU时间。要解决此问题，请优化执行后台任务的代码以提高CPU效率，或者减少应用程序在后台运行时执行的工作量。
 终止代码0xc51bad02表示监视应用程序已终止，因为它未能在分配的时间内完成后台任务。要解决此问题，请减少应用程序在后台运行时执行的工作量。
 终止代码0xc51bad03指示监视应用程序未能在分配的时间内完成后台任务，并且系统总体上十分繁忙，以至于该应用程序可能没有收到太多的CPU时间来执行后台任务。尽管应用程序可以通过减少在后台任务中执行的工作量来避免该问题，0xc51bad03但并不表示该应用程序做错了什么。该应用更有可能由于整体系统负载而无法完成其工作。
 受保护的资源违规[EXC_GUARD]
 该过程违反了受保护的资源保护。系统库可能会将某些文件描述符标记为受保护的，然后对这些描述符的正常操作将触发EXC_GUARD异常（当要对这些文件描述符进行操作时，系统将使用特殊的“受保护”专用API）。这可以帮助您快速查找问题，例如关闭由系统库打开的文件描述符。例如，如果某个应用程序关闭了用于访问支持Core Data存储的SQLite文件的文件描述符，则Core Data随后会神秘地崩溃。保护异常使这些问题能更快地被发现，从而使它们更易于调试。

 来自较新版本的iOS的崩溃报告EXC_GUARD在“ 异常子类型”和“ 异常消息”字段中包含有关导致异常的操作的易于理解的详细信息。在来自macOS或更旧版本的iOS的崩溃报告中，此信息被编码为第一个“ 异常代码”作为位字段，其分解如下：

 [63:61]-保护类型：受保护资源的类型。值0x2表示资源是文件描述符。
 [60:32]-风味：触发​​违规的条件。
 如果(1 << 0)设置了第一位，则进程尝试close()在受保护的文件描述符上调用。
 如果第二(1 << 1)位设置，过程试图调用dup()，dup2()或fcntl()用F_DUPFD或F_DUPFD_CLOEXEC命令在把守的文件描述符。
 如果(1 << 2)设置了第三位，则进程尝试通过套接字发送受保护的文件描述符。
 如果(1 << 4)设置了第五位，则进程尝试写入受保护的文件描述符。
 [31：0]-文件描述符：进程尝试修改的受保护文件描述符。
 资源限制[EXC_RESOURCE]
 该过程超出了资源消耗限制。这是来自操作系统的通知，通知该进程正在使用太多资源。确切的资源列在“ 异常子类型”字段中。如果Exception Note字段包含NON-FATAL CONDITION，则即使生成了崩溃报告，该进程也没有被杀死。

 异常子类型MEMORY表示进程已超过系统施加的内存限制。这可能是终止使用过多内存的先决条件。
 异常子类型WAKEUPS表示该进程中的线程每秒被唤醒太多次，这迫使CPU非常频繁地唤醒并消耗电池寿命。
 通常，这是由线程间通信（通常使用peformSelector:onThread:或dispatch_async）引起的，这种通信不经意地发生的次数比应有的多。由于触发此异常的通信种类经常发生，因此通常会有多个后台线程具有非常相似的Backtraces（回溯） -指示通信起源。

 其他异常类型
 一些崩溃报告可能包含未命名的Exception Type，它将以十六进制值（例如00000020）打印。如果您收到这些崩溃报告之一，请直接查看“ 异常代码”字段以了解更多信息。

 异常代码0xbaaaaaad表示该日志是整个系统的堆栈快照，而不是崩溃报告。要拍摄快照，请同时按侧面按钮和两个音量按钮。这些日志通常是用户意外创建的，它们并不表示错误。
 异常代码0xbad22222表示VoIP应用程序已被iOS终止，因为它恢复得太频繁了。
 异常代码0x8badf00d表示应用程序已被iOS终止，因为发生了看门狗超时。该应用程序启动，终止或响应系统事件花了太长时间。一个常见的原因是在主线程上进行同步网络连接。无论执行什么操作，都Thread 0需要将其移至后台线程，或进行不同的处理，以免阻塞主线程。
 异常代码0xc00010ff表示该应用程序因响应热事件而被操作系统杀死。这可能是由于发生此崩溃的特定设备的问题或其运行的环境引起的。有关使您的应用程序更有效运行的提示，请参阅iOS的性能和Power Develops with Instruments WWDC会话。
 异常代码0xdead10cc表示应用程序已被操作系统终止，因为在挂起过程中该应用程序保留了文件锁或sqlite数据库锁。如果您的应用程序在挂起时对锁定的文件或sqlite数据库执行操作，则它必须请求额外的后台执行时间来完成这些操作，并在挂起之前放弃锁定。
 异常代码0x2bad45ec表示应用程序由于安全违规而已被iOS终止。终止描述“在安全模式下检测到进程在执行不安全绘图时”，表示该应用尝试在不允许的情况下（例如在屏幕锁定时）在屏幕上进行绘制。用户可能不会注意到此终止，因为此终止发生时，屏幕关闭或显示了锁定屏幕。
 注意：  使用应用程序切换器终止已暂停的应用程序不会生成崩溃报告。应用暂停后，它随时可以通过iOS终止，因此不会生成崩溃报告。

 其他诊断信息
 本节包括特定于终止类型的其他诊断信息，其中可能包括：

 特定于应用程序的信息：在过程终止之前捕获的框架错误消息
 内核消息：有关代码签名问题的详细信息
 Dyld错误消息：动态链接器发出的错误消息
 从macOS Sierra，iOS 10，watchOS 3和tvOS 10开始，现在大多数信息在“ 异常信息”下的“ 终止原因”字段中报告。

 您应该阅读本节，以更好地了解终止过程的情况。

 清单7   特定进程部分的节选摘录，该报告是由于找不到与之链接的框架而在终止进程时生成的崩溃报告。

 Dyld错误消息：
 Dyld消息：库未加载：@ rpath / MyCustomFramework.framework / MyCustomFramework
   引用自：/private/var/containers/Bundle/Application/CD9DB546-A449-41A4-A08B-87E57EE11354/TheElements.app/TheElements
   原因：未找到合适的图像。
 清单8   摘自“特定于应用程序的信息”部分的内容，该文件是由于进程未能快速加载其初始视图控制器而终止时生成的崩溃报告。

 特定于应用程序的信息：
 com.example.apple-samplecode.TheElements在19.81s之后无法场景创建（启动花费了0.19s的总时长20.00s）
  
 已耗用的总CPU时间（秒）：7.690（用户7.690，系统0.000），19％CPU
 应用程序经过的CPU时间（秒）：0.697，2％CPU
 回溯
 崩溃报告中最有趣的部分是进程终止时每个进程线程的回溯。这些跟踪中的每一个都与您在调试器中暂停过程时看到的类似。

 清单9   完全符号化的崩溃报告的Backtrace部分的节选。

 线程0名称：调度队列：com.apple.main-thread
 线程0崩溃：
 0 TheElements 0x000000010006bc20-[AtomicElementViewController myTransitionDidStop：完成：上下文：]（AtomicElementViewController.m：203）
 1 UIKit 0x0000000194cef0f0-[UIViewAnimationState sendDelegateAnimationDidStop：完成：] + 312
 2 UIKit 0x0000000194ceef30-[UIViewAnimationState animationDidStop：完成：] + 160
 3 QuartzCore 0x0000000192178404 CA :: Layer :: run_animation_callbacks（void *）+ 260
 4 libdispatch.dylib 0x000000018dd6d1c0 _dispatch_client_callout + 16
 5 libdispatch.dylib 0x000000018dd71d6c _dispatch_main_queue_callback_4CF + 1000
 6 CoreFoundation 0x000000018ee91f2c __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
 7 CoreFoundation 0x000000018ee8fb18 __CFRunLoopRun + 1660
 8 CoreFoundation 0x000000018edbe048 CFRunLoopRunSpecific + 444
 9 GraphicsServices 0x000000019083f198 GSEventRunModal + 180
 10 UIKit 0x0000000194d21bd0-[UIApplication _run] + 684
 11 UIKit 0x0000000194d1c908 UIApplicationMain + 208
 12 TheElements 0x00000001000653c0 main（main.m：55）
 13 libdyld.dylib 0x000000018dda05b8开始+ 4
  
 线程1：
 0 libsystem_kernel.dylib 0x000000018deb2a88 __workq_kernreturn + 8
 1个libsystem_pthread.dylib 0x000000018df75188 _pthread_wqthread + 968
 2 libsystem_pthread.dylib 0x000000018df74db4 start_wqthread + 4
  
 ...
 第一行列出了线程号和当前正在执行的调度队列的标识符。其余各行列出了有关回溯中各个堆栈帧的详细信息。从左到右：

 堆栈帧号。堆栈帧按调用顺序显示，其中零帧是停止执行时正在执行的函数。第一帧是在零帧中调用该函数的函数，依此类推。
 堆栈帧的执行功能所在的二进制文件的名称。
 对于帧零，执行暂停时正在执行的机器指令的地址。对于其余的堆栈帧，当控制权返回到堆栈帧时，下一条将执行的机器指令的地址。
 在带符号的崩溃报告中，函数在堆栈框架中的方法名称。
 例外情况
 Objective-C中的异常用于指示在运行时检测到的编程错误，例如访问索引超出范围的数组，尝试对不可变对象进行突变，未实现协议的必需方法或发送以下消息：接收器无法识别。

 注意：  向先前释放的对象发送消息可能会引发，NSInvalidArgumentException而不是因内存访问冲突而使程序崩溃。当在先前由已释放对象占用的内存中分配新对象时，会发生这种情况。如果您的应用程序由于未捕获而崩溃NSInvalidArgumentException（请-[NSObject(NSObject) doesNotRecognizeSelector:]在异常回溯中查找），请考虑使用Zombies工具对应用程序进行性能分析，以消除导致内存管理不当的可能性。

 如果未捕获到异常，则该异常将被称为未捕获的异常处理程序的函数拦截。默认的未捕获异常处理程序将异常消息记录到设备的控制台，然后终止该过程。在Last Exception Backtrace部分下，只有异常backtrace被写入生成的崩溃报告，如清单10所示。崩溃消息中省略了异常消息。如果您收到带有上次异常回溯的崩溃报告，则应该从原始设备获取控制台日志，以更好地了解导致异常的情况。

 清单10   未经符号化的崩溃报告的Last Exception Backtrace部分的节选。

 最后异常回溯：
 （0x18eee41c0 0x18d91c55c 0x18eee3e88 0x18f8ea1a0 0x195013fe4 0x1951acf20 0x18ee03dc4 0x1951ab8f4 0x195458128 0x19545fa20 0x19545fc7c 0x19545ff70 0x194de4594 0x194e94e8c 0x194f47d8c 0x194f39b40 0x194ca92ac 0x18ee917dc 0x18ee8f40c 0x18ee8f89c 0x18edbe048 0x19083f198 0x194d21bd0 0x194d1c908 0x1000ad45c 0x18dda05b8）
 带有Last Exception Backtrace仅包含十六进制地址的崩溃日志必须用符号表示，以产生可用的backtrace，如清单11所示。

 清单11   带有符号的崩溃报告中的Last Exception Backtrace部分的节选。在应用的故事板上加载场景时引发了此异常。缺少与场景中某个元素的连接的相应IBOutlet。

 最后异常回溯：
 0 CoreFoundation 0x18eee41c0 __exceptionPreprocess + 124
 1个libobjc.A.dylib 0x18d91c55c objc_exception_throw + 56
 2 CoreFoundation 0x18eee3e88-[NSException提高] + 12
 3基础0x18f8ea1a0-[NSObject（NSKeyValueCoding）setValue：forKey：] + 272
 4 UIKit 0x195013fe4-[UIViewController setValue：forKey：] + 104
 5 UIKit 0x1951acf20-[UIRuntimeOutletConnection连接] + 124
 6 CoreFoundation 0x18ee03dc4-[NSArray makeObjectsPerformSelector：] + 232
 7 UIKit 0x1951ab8f4-[UINib InstantiateWithOwner：options：] + 1756
 8 UIKit 0x195458128-[UIStoryboard实例化ViewControllerWithIdentifier：] + 196
 9 UIKit 0x19545fa20-[UIStoryboardSegueTemplate实例化OrFindDestinationViewControllerWithSender：] + 92
 10 UIKit 0x19545fc7c-[UIStoryboardSegueTemplate _perform：] + 56
 11 UIKit 0x19545ff70-[UIStoryboardSegueTemplate执行：] + 160
 12 UIKit 0x194de4594-[UITableView _selectRowAtIndexPath：animated：scrollPosition：notifyDelegate：] + 1352
 13 UIKit 0x194e94e8c-[UITableView _userSelectRowAtPendingSelectionIndexPath：] + 268
 14 UIKit 0x194f47d8c _runAfterCACommitDeferredBlocks + 292
 15 UIKit 0x194f39b40 _cleanUpAfterCAFlushAndRunDeferredBlocks + 560
 16 UIKit 0x194ca92ac _afterCACommitHandler + 168
 17 CoreFoundation 0x18ee917dc __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ + 32
 18 CoreFoundation 0x18ee8f40c __CFRunLoopDoObservers + 372
 19 CoreFoundation 0x18ee8f89c __CFRunLoopRun + 1024
 20 CoreFoundation 0x18edbe048 CFRunLoopRunSpecific + 444
 21 GraphicsServices 0x19083f198 GSEventRunModal + 180
 22 UIKit 0x194d21bd0-[UIApplication _run] + 684
 23 UIKit 0x194d1c908 UIApplicationMain + 208
 24 TheElements 0x1000ad45c main（main.m：55）
 25 libdyld.dylib 0x18dda05b8开始+ 4
 注意：  如果发现没有捕获到由应用程序在异常处理域设置中引发的异常，请在构建应用程序或库时确认未指定该-no_compact_unwind标志。

 64位iOS使用“零成本”异常实现。在“零成本”系统中，每个函数都有其他数据，这些数据描述了在函数上引发异常时如何展开堆栈。如果在没有展开数据的堆栈帧上引发异常，则异常处理将无法继续，并且进程将停止。可能在堆栈的更上方有一个异常处理程序，但是如果没有一帧的展开数据，则无法从引发异常的堆栈帧到达那里。指定该-no_compact_unwind标志意味着您没有该代码的展开表，因此您不能在这些函数之间引发异常。

 另外，如果您在应用程序或库中包含普通C代码，则可能需要指定-funwind-tables标志以包括该代码中所有函数的展开表。

 线程状态
 本节列出了崩溃的线程的线程状态。这是寄存器列表及其在执行暂停时的值。读取崩溃报告时，不必了解线程状态，但是您可以使用此信息来更好地了解崩溃的状况。

 清单12   摘自ARM64设备的崩溃报告中的“线程状态”部分。

 线程0因ARM线程状态（64位）而崩溃：
     x0：0x0000000000000000 x1：0x000000019ff776c8 x2：0x0000000000000000 x3：0x000000019ff776c8
     x4：0x0000000000000000 x5：0x0000000000000001 x6：0x0000000000000000 x7：0x00000000000000d0
     x8：0x0000000100023920 x9：0x0000000000000000 x10：0x000000019ff7dff0 x11：0x0000000c0000000f
    x12：0x000000013e63b4d0 x13：0x000001a19ff75009 x14：0x0000000000000000 x15：0x0000000000000000
    x16：0x0000000187b3f1b9 x17：0x0000000181ed488c x18：0x0000000000000000 x19：0x000000013e544780
    x20：0x000000013fa49560 x21：0x0000000000000001 x22：0x000000013fc05f90 x23：0x000000010001e069
    x24：0x0000000000000000 x25：0x000000019ff776c8 x26：0xee009ec07c8c24c7 x27：0x0000000000000020
    x28：0x0000000000000000 fp：0x000000016fdf29e0 lr：0x0000000100017cf8
     sp：0x000000016fdf2980 pc：0x0000000100017d14 cpsr：0x60000000
 二进制图像
 本节列出了终止时在进程中加载​​的二进制映像。

 清单13   崩溃报告的二进制图像部分中应用程序条目的摘录。

 二进制图像：
 0x100060000-0x100073fff TheElements arm64 <2defdbea0c873a52afa458cf14cd169e> /var/containers/Bundle/Application/888C1FA2-3666-4AE2-9E8E-62E2F787DEC1/TheElements.app/TheElements
 ...
 每行包括单个二进制映像的以下详细信息：

 进程中的二进制映像的地址空间。
 二进制文件的二进制文件名称或捆绑包标识符（仅适用于macOS）。在来自macOS的崩溃报告中，如果二进制文件是操作系统的一部分，则前缀（+）。
 （仅适用于macOS）二进制文件的简短版本字符串和捆绑软件版本，以破折号分隔。
 （仅适用于iOS）二进制映像的体系结构。二进制文件可以包含多个“片段”，每个“片段”都支持一种架构。这些片中只有一个被加载到进程中。
 一个唯一标识二进制映像的UUID。该值随二进制文件的每次构建而变化，并在符号化崩溃报告时用于定位相应的dSYM文件。
 磁盘上二进制文件的路径。
 回到顶部
 了解内存不足报告
 当检测到内存不足的情况时，iOS中的虚拟内存系统将依靠应用程序的协作来释放内存。低内存通知将作为释放内存的请求发送到所有正在运行的应用程序和进程，以减少使用的内存量。如果仍然存在内存压力，系统可能会终止后台进程以减轻内存压力。如果可以释放足够的内存，则您的应用程序将继续运行。如果没有，您的应用程序将被iOS终止，因为没有足够的内存来满足应用程序的需求，并且将生成内存不足报告并将其存储在设备上。

 低内存报告的格式与其他崩溃报告的不同之处在于，应用程序线程没有回溯。低内存报告以类似于崩溃报告标头的标头开头。标头后是一组字段，这些字段列出了系统范围的内存统计信息。记下“ 页面大小”字段的值。低内存报告中每个进程的内存使用情况以内存页数为单位进行报告。

 内存不足报告中最重要的部分是进程表。下表列出了生成低内存报告时所有正在运行的进程，包括系统守护程序。如果某个流程被“简化”，则原因将列在[原因]列下。可能由于多种原因而中止流程：

 [per-process-limit]：进程超过了系统施加的内存限制。系统为所有应用程序建立驻留内存的每个进程限制。超过此限制将使该过程有资格终止。
 注意：  扩展具有更低的每进程内存限制。某些技术，例如地图视图和SpriteKit，会带来较高的基线内存成本，并且可能不适合在扩展中使用。

 [vm-pageshortage] / [vm-thrashing] / [vm]：由于内存压力，进程被终止。
 [vnode-limit]：打开了太多文件。
 注意：  当vnode几乎耗尽时，系统避免杀死最前端的应用程序。这意味着您的应用程序在后台运行时，即使不是多余的vnode使用量的来源，也可能会终止。

 [highwater]：系统守护程序越过了高水位标记以用于内存使用。
 [jettisoned]：由于其他一些原因，该过程被搁置了。
 如果您没有在应用程序/扩展名过程旁边看到原因，则表明崩溃的原因不是内存不足。查找.crash文件（在上一节中进行了介绍）以获取更多信息。

 当看到内存不足崩溃时，而不是担心终止时代码的哪个部分正在执行，您应该调查内存使用模式以及对内存不足警告的响应。在您的应用程序中查找内存问题列出了有关如何使用泄漏工具发现内存泄漏以及如何使用分配工具的标记堆功能避免遗弃内存的详细步骤。《内存使用性能指南》讨论了响应低内存通知的正确方法，以及有效使用内存的许多技巧。还建议您检查WWDC 2010会话“ 使用仪器进行高级内存分析”。

 重要：  泄漏和分配工具不会跟踪所有内存使用情况。您需要使用VM Tracker仪器（包含在“仪器分配”模板中）运行您的应用程序，以查看总内存使用情况。默认情况下，VM Tracker被禁用。要使用VM Tracker来分析您的应用程序，请单击仪器，选中“自动快照”标志，或手动按“立即快照”按钮。

 回到顶部
 相关文件
 有关如何使用Instruments Zombies模板修复内存释放过多崩溃的信息，请参见使用Zombies Trace Template消除Zombies。

 有关应用程序归档的更多信息，请参阅《App分发指南》。

 有关解释崩溃日志的详细信息，请参阅了解iPhone OS WWDC 2010会话上的崩溃报告。
 
 */