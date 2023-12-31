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

package android.hardware.tetheroffload;

@VintfStability
@Backing(type="int")
enum OffloadCallbackEvent {
    /**
     * Indicate that a working configuration has been programmed and the
     * hardware management process has begun forwarding traffic.
     */
    OFFLOAD_STARTED = 1,
    /**
     * Indicate that an error has occurred which has disrupted hardware
     * acceleration.  Software routing may still be attempted; however,
     * statistics may be temporarily unavailable.  Statistics may be recovered
     * after OFFLOAD_SUPPORT_AVAILABLE event is fired.
     */
    OFFLOAD_STOPPED_ERROR = 2,
    /**
     * Indicate that the device has moved to a RAT on which hardware
     * acceleration is not supported.  Subsequent calls to setUpstreamParameters
     * and add/removeDownstream will likely fail and cannot be presumed to be
     * saved inside of the hardware management process.  Upon receiving
     * OFFLOAD_SUPPORT_AVAILABLE, the client may reprogram the hardware
     * management process to begin offload again.
     */
    OFFLOAD_STOPPED_UNSUPPORTED = 3,
    /**
     * Indicate that the hardware management process is willing and able to
     * provide support for hardware acceleration at this time.  If applicable,
     * the client may query for statistics.  If offload is desired, the client
     * must reprogram the hardware management process.
     */
    OFFLOAD_SUPPORT_AVAILABLE = 4,
    /**
     * Hardware acceleration is no longer in effect and must be reprogrammed
     * in order to resume.  This event is fired when the limit, applied in
     * setDataLimit, has expired.  It is recommended that the client query for
     * statistics immediately after receiving this event.
     */
    OFFLOAD_STOPPED_LIMIT_REACHED = 5,
    /**
     * This event is fired when the quota, applied in setDataWarningAndLimit, has expired. It is
     * recommended that the client query for statistics immediately after receiving this event.
     * Any offloaded traffic will continue to be offloaded until offload is stopped or
     * OFFLOAD_STOPPED_LIMIT_REACHED is sent.
     */
    OFFLOAD_WARNING_REACHED = 6,
}
