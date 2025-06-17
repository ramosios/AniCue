
import XCTest
@testable import AniCue

final class UserPreferencesViewModelTests: XCTestCase {

    var viewModel: UserPreferencesViewModel!
    var testFileURL: URL!

    override func setUp() {
        super.setUp()

        // Create a unique file path for each test
        let uniqueFileName = "test_user_preferences_\(UUID().uuidString).json"
        let tempDir = FileManager.default.temporaryDirectory
        testFileURL = tempDir.appendingPathComponent(uniqueFileName)

        // Initialize without triggering loadAnswers, then inject override path
        viewModel = UserPreferencesViewModel(useInitialLoad: false)
        viewModel.overrideFileURL = testFileURL
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: testFileURL)
        viewModel = nil
        super.tearDown()
    }

    func testSaveAndLoadAnswers() {
        let testAnswers = ["Action", "Evening", "Subbed"]
        viewModel.selectedAnswers = testAnswers
        viewModel.saveAnswers()

        // Simulate a fresh instance
        let reloadViewModel = UserPreferencesViewModel(useInitialLoad: false)
        reloadViewModel.overrideFileURL = testFileURL
        reloadViewModel.loadAnswers()

        XCTAssertEqual(reloadViewModel.selectedAnswers, testAnswers, "Loaded answers should match saved answers")
    }

    func testEmptyLoadDoesNotCrash() {
        try? FileManager.default.removeItem(at: testFileURL) // Ensure no file exists
        viewModel.loadAnswers()
        XCTAssertEqual(viewModel.selectedAnswers, ["", "", ""], "Should remain default if file not found")
    }
}

