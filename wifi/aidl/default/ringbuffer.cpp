/*
 * Copyright (C) 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "ringbuffer.h"

#include <android-base/logging.h>

namespace aidl {
namespace android {
namespace hardware {
namespace wifi {

Ringbuffer::Ringbuffer(size_t maxSize) : size_(0), maxSize_(maxSize) {}

enum Ringbuffer::AppendStatus Ringbuffer::append(const std::vector<uint8_t>& input) {
    if (input.size() == 0) {
        return AppendStatus::FAIL_IP_BUFFER_ZERO;
    }
    if (input.size() > maxSize_) {
        LOG(INFO) << "Oversized message of " << input.size() << " bytes is dropped";
        return AppendStatus::FAIL_IP_BUFFER_EXCEEDED_MAXSIZE;
    }
    data_.push_back(input);
    size_ += input.size() * sizeof(input[0]);
    while (size_ > maxSize_) {
        if (data_.front().size() <= 0 || data_.front().size() > maxSize_) {
            LOG(ERROR) << "First buffer in the ring buffer is Invalid. Size: "
                       << data_.front().size();
            return AppendStatus::FAIL_RING_BUFFER_CORRUPTED;
        }
        size_ -= data_.front().size() * sizeof(data_.front()[0]);
        data_.pop_front();
    }
    return AppendStatus::SUCCESS;
}

const std::list<std::vector<uint8_t>>& Ringbuffer::getData() const {
    return data_;
}

void Ringbuffer::clear() {
    data_.clear();
    size_ = 0;
}

}  // namespace wifi
}  // namespace hardware
}  // namespace android
}  // namespace aidl
