init:
	$(MAKE) xcodegen

format:
	swift format --configuration .swift-format --in-place --recursive ./SignalVSNoiseKit

gitignore-flush:
	git rm -r --cached .
	git add --all
	git commit -am "[conf] Gitignore flush" || true

update-scheme:
	cp TestSVN.xcodeproj/xcshareddata/xcschemes/TestSVN.xcscheme TestSVN.xcscheme

xcodegen:
	echo "Generating TestSVN.xcodeproj..."
	killall Xcode || true
	rm -rf TestSVN.xcodeproj || true
	xcodegen generate --spec project.yml || true
	cp TestSVN.xcscheme TestSVN.xcodeproj/xcshareddata/xcschemes/TestSVN.xcscheme || true
	xed . &

swift-format-dump-configuration:
	swift-format -m dump-configuration > .swift-format.ori

update-xcodegen:
	brew upgrade xcodegen