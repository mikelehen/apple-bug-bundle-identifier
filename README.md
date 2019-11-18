# apple-bug-bundle-identifier
Reproduces `[NSBundle bundleWithIdentifier]` crash with international characters in your app name.

## Repro Steps
```
git clone https://github.com/mikelehen/apple-bug-bundle-identifier.git
cd apple-bug-bundle-identifier
pod install
open BundleIdentifierBug.xcworkspace
```

Click play button to launch app.


## Result
```
thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
frame #0: 0x0000000110cf4692 CoreFoundation`CFRelease + 82
frame #1: 0x0000600002085d10
frame #2: 0x0000000110c82970 CoreFoundation`__CFBundleCopyFrameworkURLForExecutablePath + 896
frame #3: 0x0000000110c8061f CoreFoundation`_CFBundleEnsureBundleExistsForImagePath + 15
frame #4: 0x0000000110c8047d CoreFoundation`CFBundleGetBundleWithIdentifier + 221
frame #5: 0x000000010ed94551 Foundation`+[NSBundle bundleWithIdentifier:] + 26
frame #6: 0x000000010dd50c55 Ører`@nonobjc NSBundle.__allocating_init(identifier:) at <compiler-generated>:0
frame #7: 0x000000010dd50aab Ører`ViewController.viewDidLoad(self=0x00007fc04f516160) at ViewController.swift:15:9
frame #8: 0x000000010dd50d04 Ører`@objc ViewController.viewDidLoad() at <compiler-generated>:0
frame #9: 0x0000000112f3143b UIKitCore`-[UIViewController loadViewIfRequired] + 1183
frame #10: 0x0000000112f31868 UIKitCore`-[UIViewController view] + 27
frame #11: 0x0000000113569c33 UIKitCore`-[UIWindow addRootViewControllerViewIfPossible] + 122
frame #12: 0x000000011356a327 UIKitCore`-[UIWindow _setHidden:forced:] + 289
frame #13: 0x000000011357cf86 UIKitCore`-[UIWindow makeKeyAndVisible] + 42
frame #14: 0x000000011352cf1c UIKitCore`-[UIApplication _callInitializationDelegatesForMainScene:transitionContext:] + 4555
frame #15: 0x00000001135320c6 UIKitCore`-[UIApplication _runWithMainScene:transitionContext:completion:] + 1617
frame #16: 0x0000000112d776d6 UIKitCore`__111-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:]_block_invoke + 904
frame #17: 0x0000000112d7ffce UIKitCore`+[_UICanvas _enqueuePostSettingUpdateTransactionBlock:] + 153
frame #18: 0x0000000112d772ec UIKitCore`-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:] + 236
frame #19: 0x0000000112d77c48 UIKitCore`-[__UICanvasLifecycleMonitor_Compatability activateEventsOnly:withContext:completion:] + 1091
frame #20: 0x0000000112d75fba UIKitCore`__82-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:]_block_invoke + 782
frame #21: 0x0000000112d75c71 UIKitCore`-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:] + 433
frame #22: 0x0000000112d7a9b6 UIKitCore`__125-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:]_block_invoke + 576
frame #23: 0x0000000112d7b610 UIKitCore`_performActionsWithDelayForTransitionContext + 100
frame #24: 0x0000000112d7a71d UIKitCore`-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:] + 223
frame #25: 0x0000000112d7f6d0 UIKitCore`-[_UICanvas scene:didUpdateWithDiff:transitionContext:completion:] + 392
frame #26: 0x00000001135309a8 UIKitCore`-[UIApplication workspace:didCreateScene:withTransitionContext:completion:] + 514
frame #27: 0x00000001130e7dfa UIKitCore`-[UIApplicationSceneClientAgent scene:didInitializeWithEvent:completion:] + 361
frame #28: 0x000000011be2d125 FrontBoardServices`-[FBSSceneImpl _didCreateWithTransitionContext:completion:] + 448
frame #29: 0x000000011be36ed6 FrontBoardServices`__56-[FBSWorkspace client:handleCreateScene:withCompletion:]_block_invoke_2 + 283
frame #30: 0x000000011be36700 FrontBoardServices`__40-[FBSWorkspace _performDelegateCallOut:]_block_invoke + 53
frame #31: 0x000000011086ddb5 libdispatch.dylib`_dispatch_client_callout + 8
frame #32: 0x00000001108712ba libdispatch.dylib`_dispatch_block_invoke_direct + 300
frame #33: 0x000000011be68146 FrontBoardServices`__FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 30
frame #34: 0x000000011be67dfe FrontBoardServices`-[FBSSerialQueue _performNext] + 451
frame #35: 0x000000011be68393 FrontBoardServices`-[FBSSerialQueue _performNextFromRunLoopSource] + 42
frame #36: 0x0000000110cf2be1 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
frame #37: 0x0000000110cf2463 CoreFoundation`__CFRunLoopDoSources0 + 243
frame #38: 0x0000000110cecb1f CoreFoundation`__CFRunLoopRun + 1231
frame #39: 0x0000000110cec302 CoreFoundation`CFRunLoopRunSpecific + 626
frame #40: 0x0000000118d862fe GraphicsServices`GSEventRunModal + 65
frame #41: 0x0000000113533ba2 UIKitCore`UIApplicationMain + 140
frame #42: 0x000000010dd51c9b Ører`main at AppDelegate.swift:12:7
frame #43: 0x00000001108e2541 libdyld.dylib`start + 1
frame #44: 0x00000001108e2541 libdyld.dylib`start + 1
```

## The Issue
If you change your Build Settings > Packaging > Product Name to certain strings containing international characters, e.g. `Ører` then `[NSBundle bundleWithIdentifier]` crashes with the above callstack.

![Repro Image](repro.png)

It's worth noticing that when you change your package name to `Ører` then your app ends up installing to a `Ører.app/` folder on disk.  Presumably there's a bug with constructing file paths or something.
